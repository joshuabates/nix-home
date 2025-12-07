; extends

; Fold type annotations
(type_annotation) @fold

; Fold type parameters
(type_parameters) @fold

; Fold function return types
(function_signature
  return_type: (_) @fold)

(function_declaration
  return_type: (_) @fold)

(arrow_function
  return_type: (_) @fold)

(method_definition
  return_type: (_) @fold)

; Fold interface/type definitions (optional)
; (interface_declaration) @fold
; (type_alias_declaration) @fold