use std::path::{Path, PathBuf};
use std::collections::HashMap;

/// Bitcode cache entry for a package
#[derive(Debug, Clone)]
pub struct BitcodeEntry {
    pub package: String,
    pub version: String,
    pub bc_path: PathBuf,       // path to .bc file
    pub type_sig_path: PathBuf, // path to type signatures file
    pub hash: String,           // content hash of source
    pub size_bytes: u64,
}

/// The bitcode cache manager
pub struct BitcodeCache {
    cache_dir: PathBuf,
    index: HashMap<String, BitcodeEntry>, // key: "pkg@version"
}

impl BitcodeCache {
    /// Open or create a bitcode cache
    pub fn open(cache_dir: &Path) -> Result<Self, String> {
        let bc_dir = cache_dir.join("bitcode");
        std::fs::create_dir_all(&bc_dir)
            .map_err(|e| format!("cannot create bitcode cache: {}", e))?;

        // Load index
        let index_path = bc_dir.join("index.toml");
        let index = if index_path.exists() {
            load_index(&index_path)?
        } else {
            HashMap::new()
        };

        Ok(Self { cache_dir: bc_dir, index })
    }

    /// Check if bitcode exists for a package version
    pub fn has(&self, package: &str, version: &str) -> bool {
        let key = format!("{}@{}", package, version);
        if let Some(entry) = self.index.get(&key) {
            entry.bc_path.exists()
        } else {
            false
        }
    }

    /// Get cached bitcode path for a package version
    pub fn get(&self, package: &str, version: &str) -> Option<&BitcodeEntry> {
        let key = format!("{}@{}", package, version);
        self.index.get(&key).filter(|e| e.bc_path.exists())
    }

    /// Store bitcode for a package version
    pub fn store(
        &mut self,
        package: &str,
        version: &str,
        bc_data: &[u8],
        type_signatures: &str,
        content_hash: &str,
    ) -> Result<BitcodeEntry, String> {
        let key = format!("{}@{}", package, version);
        let bc_filename = format!("{}_{}.bc", package.replace('-', "_"), version.replace('.', "_"));
        let sig_filename = format!("{}_{}.sig", package.replace('-', "_"), version.replace('.', "_"));

        let bc_path = self.cache_dir.join(&bc_filename);
        let sig_path = self.cache_dir.join(&sig_filename);

        std::fs::write(&bc_path, bc_data)
            .map_err(|e| format!("cannot write bitcode: {}", e))?;
        std::fs::write(&sig_path, type_signatures)
            .map_err(|e| format!("cannot write type signatures: {}", e))?;

        let entry = BitcodeEntry {
            package: package.to_string(),
            version: version.to_string(),
            bc_path: bc_path.clone(),
            type_sig_path: sig_path,
            hash: content_hash.to_string(),
            size_bytes: bc_data.len() as u64,
        };

        self.index.insert(key, entry.clone());
        self.save_index()?;

        Ok(entry)
    }

    /// Remove cached bitcode for a package version
    pub fn remove(&mut self, package: &str, version: &str) -> Result<(), String> {
        let key = format!("{}@{}", package, version);
        if let Some(entry) = self.index.remove(&key) {
            std::fs::remove_file(&entry.bc_path).ok();
            std::fs::remove_file(&entry.type_sig_path).ok();
            self.save_index()?;
        }
        Ok(())
    }

    /// Get total cache size in bytes
    pub fn total_size(&self) -> u64 {
        self.index.values().map(|e| e.size_bytes).sum()
    }

    /// List all cached entries
    pub fn list(&self) -> Vec<&BitcodeEntry> {
        self.index.values().collect()
    }

    /// Verify a cached entry's hash matches expected
    pub fn verify(&self, package: &str, version: &str, expected_hash: &str) -> Result<bool, String> {
        let key = format!("{}@{}", package, version);
        match self.index.get(&key) {
            Some(entry) => Ok(entry.hash == expected_hash),
            None => Ok(false),
        }
    }

    /// Garbage collect: remove entries not in the keep list
    pub fn gc(&mut self, keep: &[(String, String)]) -> Result<usize, String> {
        let keep_keys: std::collections::HashSet<String> = keep.iter()
            .map(|(p, v)| format!("{}@{}", p, v))
            .collect();

        let to_remove: Vec<String> = self.index.keys()
            .filter(|k| !keep_keys.contains(*k))
            .cloned()
            .collect();

        let count = to_remove.len();
        for key in to_remove {
            if let Some(entry) = self.index.remove(&key) {
                std::fs::remove_file(&entry.bc_path).ok();
                std::fs::remove_file(&entry.type_sig_path).ok();
            }
        }

        if count > 0 {
            self.save_index()?;
        }

        Ok(count)
    }

    fn save_index(&self) -> Result<(), String> {
        let index_path = self.cache_dir.join("index.toml");
        let mut content = String::from("# Forge bitcode cache index\n\n");

        let mut entries: Vec<_> = self.index.iter().collect();
        entries.sort_by_key(|(k, _)| (*k).clone());

        for (key, entry) in entries {
            content.push_str(&format!("[\"{}\"]\n", key));
            content.push_str(&format!("package = \"{}\"\n", entry.package));
            content.push_str(&format!("version = \"{}\"\n", entry.version));
            content.push_str(&format!("bc_path = \"{}\"\n", entry.bc_path.display()));
            content.push_str(&format!("type_sig_path = \"{}\"\n", entry.type_sig_path.display()));
            content.push_str(&format!("hash = \"{}\"\n", entry.hash));
            content.push_str(&format!("size_bytes = {}\n\n", entry.size_bytes));
        }

        std::fs::write(&index_path, &content)
            .map_err(|e| format!("cannot write index: {}", e))
    }
}

fn load_index(path: &Path) -> Result<HashMap<String, BitcodeEntry>, String> {
    let content = std::fs::read_to_string(path)
        .map_err(|e| format!("cannot read index: {}", e))?;

    let toml_val: toml::Value = toml::from_str(&content)
        .map_err(|e| format!("invalid index: {}", e))?;

    let mut index = HashMap::new();

    if let Some(table) = toml_val.as_table() {
        for (key, val) in table {
            if let Some(entry_table) = val.as_table() {
                let entry = BitcodeEntry {
                    package: entry_table.get("package").and_then(|v| v.as_str()).unwrap_or("").to_string(),
                    version: entry_table.get("version").and_then(|v| v.as_str()).unwrap_or("").to_string(),
                    bc_path: PathBuf::from(entry_table.get("bc_path").and_then(|v| v.as_str()).unwrap_or("")),
                    type_sig_path: PathBuf::from(entry_table.get("type_sig_path").and_then(|v| v.as_str()).unwrap_or("")),
                    hash: entry_table.get("hash").and_then(|v| v.as_str()).unwrap_or("").to_string(),
                    size_bytes: entry_table.get("size_bytes").and_then(|v| v.as_integer()).unwrap_or(0) as u64,
                };
                index.insert(key.clone(), entry);
            }
        }
    }

    Ok(index)
}

/// Build strategy: determines whether to compile from source or use cached bitcode
#[derive(Debug)]
pub enum BuildStrategy {
    /// Use cached bitcode -- fastest
    UseCachedBitcode(BitcodeEntry),
    /// Compile from Forge source, cache the result
    CompileAndCache,
    /// Use cached static library (native package)
    UseCachedStaticLib(PathBuf),
    /// Build native code from source
    BuildNativeFromSource,
}

/// Determine build strategy for a dependency
pub fn determine_build_strategy(
    cache: &BitcodeCache,
    package: &str,
    version: &str,
    is_native: bool,
    content_hash: Option<&str>,
) -> BuildStrategy {
    // Check bitcode cache
    if let Some(entry) = cache.get(package, version) {
        // Verify hash if available
        if let Some(expected) = content_hash {
            if entry.hash == expected {
                return BuildStrategy::UseCachedBitcode(entry.clone());
            }
            // Hash mismatch -- need recompile
        } else {
            return BuildStrategy::UseCachedBitcode(entry.clone());
        }
    }

    if is_native {
        BuildStrategy::BuildNativeFromSource
    } else {
        BuildStrategy::CompileAndCache
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_cache_store_and_retrieve() {
        let tmp = std::env::temp_dir().join("forge_bc_test");
        let _ = fs::remove_dir_all(&tmp);

        let mut cache = BitcodeCache::open(&tmp).unwrap();
        assert!(!cache.has("test-pkg", "1.0.0"));

        let entry = cache.store(
            "test-pkg", "1.0.0",
            b"fake bitcode data",
            "fn test() -> int",
            "sha256:abc123",
        ).unwrap();

        assert!(cache.has("test-pkg", "1.0.0"));
        assert_eq!(entry.size_bytes, b"fake bitcode data".len() as u64);

        let retrieved = cache.get("test-pkg", "1.0.0").unwrap();
        assert_eq!(retrieved.hash, "sha256:abc123");

        // Cleanup
        let _ = fs::remove_dir_all(&tmp);
    }

    #[test]
    fn test_cache_gc() {
        let tmp = std::env::temp_dir().join("forge_bc_gc_test");
        let _ = fs::remove_dir_all(&tmp);

        let mut cache = BitcodeCache::open(&tmp).unwrap();
        cache.store("pkg-a", "1.0.0", b"a", "", "").unwrap();
        cache.store("pkg-b", "2.0.0", b"b", "", "").unwrap();
        cache.store("pkg-c", "3.0.0", b"c", "", "").unwrap();

        // Keep only pkg-a
        let removed = cache.gc(&[("pkg-a".to_string(), "1.0.0".to_string())]).unwrap();
        assert_eq!(removed, 2);
        assert!(cache.has("pkg-a", "1.0.0"));
        assert!(!cache.has("pkg-b", "2.0.0"));

        let _ = fs::remove_dir_all(&tmp);
    }

    #[test]
    fn test_build_strategy_cached() {
        let tmp = std::env::temp_dir().join("forge_bc_strategy_test");
        let _ = fs::remove_dir_all(&tmp);

        let mut cache = BitcodeCache::open(&tmp).unwrap();
        cache.store("cached-pkg", "1.0.0", b"bc", "", "hash1").unwrap();

        let strategy = determine_build_strategy(&cache, "cached-pkg", "1.0.0", false, Some("hash1"));
        assert!(matches!(strategy, BuildStrategy::UseCachedBitcode(_)));

        let strategy = determine_build_strategy(&cache, "new-pkg", "1.0.0", false, None);
        assert!(matches!(strategy, BuildStrategy::CompileAndCache));

        let _ = fs::remove_dir_all(&tmp);
    }
}
