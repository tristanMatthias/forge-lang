use std::time::Duration;

pub struct BuildProfile {
    pub stages: Vec<(String, Duration)>,
    pub fn_count: usize,
    pub binary_size: u64,
}

impl BuildProfile {
    pub fn new() -> Self {
        Self {
            stages: Vec::new(),
            fn_count: 0,
            binary_size: 0,
        }
    }

    pub fn add(&mut self, name: &str, duration: Duration) {
        self.stages.push((name.to_string(), duration));
    }

    pub fn total(&self) -> Duration {
        self.stages.iter().map(|(_, d)| *d).sum()
    }

    pub fn render_human(&self) -> String {
        let total = self.total();
        let total_ms = total.as_secs_f64() * 1000.0;
        let max_ms = self.stages.iter().map(|(_, d)| d.as_secs_f64() * 1000.0).fold(0.0f64, f64::max);

        let mut out = String::new();
        out.push_str("\n  Build Profile\n");
        out.push_str(&format!("  ─────────────────────────────────────\n"));

        for (name, dur) in &self.stages {
            let ms = dur.as_secs_f64() * 1000.0;
            let pct = if total_ms > 0.0 { ms / total_ms * 100.0 } else { 0.0 };
            let bar_width = if max_ms > 0.0 { (ms / max_ms * 20.0) as usize } else { 0 };
            let bar: String = "█".repeat(bar_width);
            out.push_str(&format!("  {:<12} {:>7.1}ms {:>5.1}%  {}\n", name, ms, pct, bar));
        }

        out.push_str(&format!("  ─────────────────────────────────────\n"));
        out.push_str(&format!("  Total:      {:>7.1}ms\n", total_ms));
        out.push_str(&format!("  Functions:  {}\n", self.fn_count));
        if self.binary_size > 0 {
            out.push_str(&format!("  Binary:     {} bytes\n", self.binary_size));
        }

        out
    }

    pub fn render_json(&self) -> String {
        let total = self.total();
        let stages_json: Vec<String> = self.stages.iter().map(|(name, dur)| {
            format!("    {{ \"name\": \"{}\", \"duration_ms\": {:.3} }}", name, dur.as_secs_f64() * 1000.0)
        }).collect();

        format!(
            "{{\n  \"stages\": [\n{}\n  ],\n  \"total_ms\": {:.3},\n  \"fn_count\": {},\n  \"binary_size\": {}\n}}",
            stages_json.join(",\n"),
            total.as_secs_f64() * 1000.0,
            self.fn_count,
            self.binary_size,
        )
    }
}

/// Count function declarations in a program
pub fn count_functions(program: &crate::parser::ast::Program) -> usize {
    program.statements.iter().filter(|s| {
        matches!(s, crate::parser::ast::Statement::FnDecl { .. })
        || matches!(s, crate::parser::ast::Statement::Feature(fe) if fe.feature_id == "functions" && fe.kind == "FnDecl")
    }).count()
}
