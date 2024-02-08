class Tree:
    def accept(self, visitor):
        pass

class Node(Tree):
    def __init__(self, left, right):
        self.left = left
        self.right = right
    
    def accept(self, visitor):
        return visitor.visit_node(self)

class Leaf(Tree):
    def __init__(self):
        pass
    
    def accept(self, visitor):
        return visitor.visit_leaf(self)

class Visitor:
    def visit_node(self, node):
        pass
    def visit_leaf(self, leaf):
        pass

class SizeVisitor(Visitor):
    def __init__(self):
        pass
    
    def visit_node(self, node):
        l = node.left.accept(self)
        r = node.right.accept(self)
        return l + r + 1
    
    def visit_leaf(self, leaf):
        return 1

if __name__ == '__main__':
    # Create a tree
    tree = Node(
        Node(
            Leaf(1), 
            Leaf(2)), 
        Leaf(3))
    # Create a visitor
    visitor = SizeVisitor()
    # Traverse the tree
    size = tree.accept(visitor)
    print(size)