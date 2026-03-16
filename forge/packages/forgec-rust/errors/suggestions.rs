/// Compute the Levenshtein edit distance between two strings.
pub fn levenshtein(a: &str, b: &str) -> usize {
    let a_len = a.len();
    let b_len = b.len();

    if a_len == 0 {
        return b_len;
    }
    if b_len == 0 {
        return a_len;
    }

    let mut prev: Vec<usize> = (0..=b_len).collect();
    let mut curr = vec![0; b_len + 1];

    for (i, a_ch) in a.chars().enumerate() {
        curr[0] = i + 1;
        for (j, b_ch) in b.chars().enumerate() {
            let cost = if a_ch == b_ch { 0 } else { 1 };
            curr[j + 1] = (prev[j] + cost)
                .min(prev[j + 1] + 1)
                .min(curr[j] + 1);
        }
        std::mem::swap(&mut prev, &mut curr);
    }

    prev[b_len]
}

/// Find the best "did you mean?" suggestion from a list of candidates.
/// Returns None if no candidate is within `max_dist` of the name.
pub fn did_you_mean<'a>(name: &str, candidates: &[&'a str], max_dist: usize) -> Option<&'a str> {
    candidates
        .iter()
        .filter_map(|&c| {
            let dist = levenshtein(name, c);
            if dist <= max_dist && dist > 0 {
                Some((c, dist))
            } else {
                None
            }
        })
        .min_by_key(|&(_, dist)| dist)
        .map(|(c, _)| c)
}

/// Generate a placeholder value for a given type (for error message examples)
pub fn placeholder_for_type(ty: &crate::typeck::types::Type) -> String {
    use crate::typeck::types::Type;
    match ty {
        Type::Int => "0".to_string(),
        Type::Float => "0.0".to_string(),
        Type::Bool => "false".to_string(),
        Type::String => "\"...\"".to_string(),
        Type::Void => "()".to_string(),
        Type::List(inner) => format!("[{}]", placeholder_for_type(inner)),
        Type::Nullable(inner) => placeholder_for_type(inner),
        _ => "...".to_string(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_levenshtein_identical() {
        assert_eq!(levenshtein("hello", "hello"), 0);
    }

    #[test]
    fn test_levenshtein_empty() {
        assert_eq!(levenshtein("", "abc"), 3);
        assert_eq!(levenshtein("abc", ""), 3);
        assert_eq!(levenshtein("", ""), 0);
    }

    #[test]
    fn test_levenshtein_one_char_diff() {
        assert_eq!(levenshtein("cat", "bat"), 1);
        assert_eq!(levenshtein("cat", "car"), 1);
        assert_eq!(levenshtein("cat", "cats"), 1);
    }

    #[test]
    fn test_levenshtein_multi_diff() {
        assert_eq!(levenshtein("kitten", "sitting"), 3);
        assert_eq!(levenshtein("saturday", "sunday"), 3);
    }

    #[test]
    fn test_did_you_mean_finds_closest() {
        let candidates = vec!["count", "counter", "amount", "name"];
        assert_eq!(did_you_mean("cont", &candidates, 2), Some("count"));
    }

    #[test]
    fn test_did_you_mean_single_typo() {
        let candidates = vec!["println", "print", "parse"];
        assert_eq!(did_you_mean("prinln", &candidates, 2), Some("println"));
    }

    #[test]
    fn test_did_you_mean_no_match() {
        let candidates = vec!["foo", "bar", "baz"];
        assert_eq!(did_you_mean("completely_different", &candidates, 2), None);
    }

    #[test]
    fn test_did_you_mean_exact_match_excluded() {
        let candidates = vec!["hello"];
        // Exact match (dist=0) should not be returned
        assert_eq!(did_you_mean("hello", &candidates, 2), None);
    }

    #[test]
    fn test_did_you_mean_empty_candidates() {
        let candidates: Vec<&str> = vec![];
        assert_eq!(did_you_mean("foo", &candidates, 2), None);
    }

    #[test]
    fn test_did_you_mean_prefers_shorter_distance() {
        let candidates = vec!["xyz", "abcdef", "abcd"];
        // "abce" → "abcd" is dist 1, "abcdef" is dist 3, "xyz" is dist 4
        assert_eq!(did_you_mean("abce", &candidates, 3), Some("abcd"));
    }
}
