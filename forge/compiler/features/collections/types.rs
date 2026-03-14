use crate::parser::ast::Expr;

/// AST data for a list literal expression.
#[derive(Debug, Clone)]
pub struct ListLitData {
    pub elements: Vec<Expr>,
}

impl crate::feature::FeatureNode for ListLitData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(ListLitData {
            elements: self.elements.iter().map(|e| (fns.sub_expr)(e)).collect(),
        })
    }
}

/// AST data for a map literal expression.
#[derive(Debug, Clone)]
pub struct MapLitData {
    pub entries: Vec<(Expr, Expr)>,
}

impl crate::feature::FeatureNode for MapLitData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(MapLitData {
            entries: self.entries.iter().map(|(k, v)| ((fns.sub_expr)(k), (fns.sub_expr)(v))).collect(),
        })
    }
}
