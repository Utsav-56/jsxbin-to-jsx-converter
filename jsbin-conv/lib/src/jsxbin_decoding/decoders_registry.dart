import 'abstract_node.dart';
import 'argument_list.dart';
import 'array_expr.dart';
import 'array_indexing_expr.dart';
import 'assignment_expr.dart';
import 'binary_expr.dart';
import 'conditional_expr.dart';
import 'const_declaration.dart';
import 'debugger_statement.dart';
import 'delete_expr.dart';
import 'do_while_expr.dart';
import 'expr_node.dart';
import 'for_in_statement_version1.dart';
import 'for_in_statement_version2.dart';
import 'for_statement.dart';
import 'for_statement2.dart';
import 'function_call_expr.dart';
import 'function_declaration.dart';
import 'function_expr.dart';
import 'id_node_version1.dart';
import 'id_node_version2.dart';
import 'id_ref_expr.dart';
import 'if_statement.dart';
import 'increment_expr.dart';
import 'indexing_increment_expr.dart';
import 'jump_statement.dart';
import 'logical_exp.dart';
import 'member_assignment_expr.dart';
import 'member_expr.dart';
import 'object_expr.dart';
import 'reg_exp_literal.dart';
import 'return_statement.dart';
import 'set_default_xml_namespace_expr.dart';
import 'statement_list.dart';
import 'switch_statement.dart';
import 'this_expr.dart';
import 'throw_statement.dart';
import 'try_statement.dart';
import 'unary_expr.dart';
import 'unknown_node2.dart';
import 'value_node.dart';
import 'while_statement.dart';
import 'with_statement.dart';
import 'xml_accessor_expr.dart';
import 'xml_assignment_expr.dart';
import 'xml_double_dot_descendants_expr.dart';
import 'xml_namespace_expr.dart';

/// Registers all known JSXBIN nodes into the [AbstractNode] decoders registry.
void registerAllDecoders(double version) {
  void reg(String marker, double nodeVersion, NodeFactory factory) {
    AbstractNode.registerDecoder(marker, nodeVersion, version, factory);
  }

  reg(ArgumentList().marker, AbstractNode.allVersions, () => ArgumentList());
  reg(ArrayExpr().marker, AbstractNode.allVersions, () => ArrayExpr());
  reg(ArrayIndexingExpr().marker, AbstractNode.allVersions, () => ArrayIndexingExpr());
  reg(AssignmentExpr().marker, AbstractNode.allVersions, () => AssignmentExpr());
  reg(BinaryExpr().marker, AbstractNode.allVersions, () => BinaryExpr());
  reg(ConditionalExpr().marker, AbstractNode.allVersions, () => ConditionalExpr());
  reg(ConstDeclaration().marker, AbstractNode.allVersions, () => ConstDeclaration());
  reg(DebuggerStatement().marker, AbstractNode.allVersions, () => DebuggerStatement());
  reg(DeleteExpr().marker, AbstractNode.allVersions, () => DeleteExpr());
  reg(DoWhileExpr().marker, AbstractNode.allVersions, () => DoWhileExpr());
  reg(ExprNode().marker, AbstractNode.allVersions, () => ExprNode());
  reg(ForInStatementVersion1().marker, 1.0, () => ForInStatementVersion1());
  reg(ForInStatementVersion2().marker, 2.0, () => ForInStatementVersion2());
  reg(ForStatement().marker, AbstractNode.allVersions, () => ForStatement());
  reg(ForStatement2().marker, AbstractNode.allVersions, () => ForStatement2());
  reg(FunctionCallExpr().marker, AbstractNode.allVersions, () => FunctionCallExpr());
  reg(
    FunctionDeclaration().marker,
    AbstractNode.allVersions,
    () => FunctionDeclaration(),
  );
  reg(FunctionExpr().marker, AbstractNode.allVersions, () => FunctionExpr());
  reg(IdNodeVersion1().marker, 1.0, () => IdNodeVersion1());
  reg(IdNodeVersion2().marker, 2.0, () => IdNodeVersion2());
  reg(IdRefExpr().marker, AbstractNode.allVersions, () => IdRefExpr());
  reg(IfStatement().marker, AbstractNode.allVersions, () => IfStatement());
  reg(IncrementExpr().marker, AbstractNode.allVersions, () => IncrementExpr());
  reg(
    IndexingIncrementExpr().marker,
    AbstractNode.allVersions,
    () => IndexingIncrementExpr(),
  );
  reg(JumpStatement().marker, AbstractNode.allVersions, () => JumpStatement());
  reg(LogicalExp().marker, AbstractNode.allVersions, () => LogicalExp());
  reg(
    MemberAssignmentExpr().marker,
    AbstractNode.allVersions,
    () => MemberAssignmentExpr(),
  );
  reg(MemberExpr().marker, AbstractNode.allVersions, () => MemberExpr());
  reg(ObjectExpr().marker, AbstractNode.allVersions, () => ObjectExpr());
  reg(RegExpLiteral().marker, AbstractNode.allVersions, () => RegExpLiteral());
  reg(ReturnStatement().marker, AbstractNode.allVersions, () => ReturnStatement());
  reg(
    SetDefaultXMLNamespaceExpr().marker,
    AbstractNode.allVersions,
    () => SetDefaultXMLNamespaceExpr(),
  );
  reg(StatementList().marker, AbstractNode.allVersions, () => StatementList());
  reg(SwitchStatement().marker, AbstractNode.allVersions, () => SwitchStatement());
  reg(ThisExpr().marker, AbstractNode.allVersions, () => ThisExpr());
  reg(ThrowStatement().marker, AbstractNode.allVersions, () => ThrowStatement());
  reg(TryStatement().marker, AbstractNode.allVersions, () => TryStatement());
  reg(UnaryExpr().marker, AbstractNode.allVersions, () => UnaryExpr());
  reg(UnknownNode2().marker, AbstractNode.allVersions, () => UnknownNode2());
  reg(ValueNode().marker, AbstractNode.allVersions, () => ValueNode());
  reg(WhileStatement().marker, AbstractNode.allVersions, () => WhileStatement());
  reg(WithStatement().marker, AbstractNode.allVersions, () => WithStatement());
  reg(XMLAccessorExpr().marker, AbstractNode.allVersions, () => XMLAccessorExpr());
  reg(XMLAssignmentExpr().marker, AbstractNode.allVersions, () => XMLAssignmentExpr());
  reg(
    XMLDoubleDotDescendantsExpr().marker,
    AbstractNode.allVersions,
    () => XMLDoubleDotDescendantsExpr(),
  );
  reg(XMLNamespaceExpr().marker, AbstractNode.allVersions, () => XMLNamespaceExpr());
}
