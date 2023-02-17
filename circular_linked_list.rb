# Adapted from: https://gist.github.com/amiralles/dcf84f1061c7df2961853906ab427542
# and https://gist.github.com/amiralles/874feaa611c1316b7f99155b70822fa3

class CircularList
    class Node
        attr_accessor :next, :prev, :data
        def initialize data
            self.data = data
            self.next = nil
            self.prev = nil
        end
    end

    attr_accessor :head, :current, :length

    # Initialize an empty lits.
    # Complexity: O(1).
    def initialize
        self.head = nil
        self.current = nil
        self.length = 0
    end


    # Inserts a new item at the end of the list.
    # Complexity: O(n).
    def insert_end data
        # We have to find the last node and insert the new node right next to it.
        self.current = self.head
        i = 0;
        while ((i += 1) < self.length)
            self.move_next
        end

        return insert_after(self.current, data)
    end

    # Inserts a new item at current position.
    # Complexity: O(n).
    def insert_current data
        return insert_after(self.current.prev, data)
    end

    # Inserts a new node next to the specified node.
    # Complexity: O(1).
    def insert_after prev_node, data
        new_node = Node.new data
        if self.length == 0
            self.head = new_node.next = new_node.prev = new_node
        else
            new_node.next = prev_node.next
            new_node.prev = prev_node
            new_node.next.prev = new_node
            prev_node.next = new_node
        end
        self.length += 1
        self.current = new_node
    end

    # Removes an item from the list.
    # Complexity: O(n).
    def remove node
        return nil unless node
        return nil unless self.length > 0

        # head?
        return remove_next node if (self.length == 1)

        # Find the precedent node to the node we
        # want to remove.
        # prev = nil
        # self.current = self.head
        # while ((prev = self.move_next) != node)
        # end
        # remove_next prev

        return remove_next node.prev
    end


    # Removes the node that is next to the specified node.
    # Complexity: O(1).
    def remove_next prev_node
        return nil unless self.length > 0

        unless prev_node
            # remove head.
            self.head.next.prev = self.head.prev
            self.head.prev.next = self.head.next
            self.head = self.head.next
        else
            if prev_node.next == prev_node
                self.head = nil
            else
                node_to_delete = prev_node.next
                prev_node.next = node_to_delete&.next
                node_to_delete.next.prev = node_to_delete&.prev
                if (node_to_delete == self.head)
                    self.head = node_to_delete.next
                end
            end
        end

        self.length -= 1
        self.current = prev_node.next
        node_to_delete
    end


    # Removes all items from the list.
    # Complexity: O(n).
    def clear
        while self.length > 0
            remove self.head
        end
    end

    # Moves to the next node.
    def move_next
        self.current = self.current&.next
    end

    # Moves to the prev node.
    def move_prev
        self.current = self.current&.prev
    end

    # Conviniece methods

    # Traverse all of the elements from the list without wrapping around.
    # (Starts from the head node and halts when gets back to it.)
    def full_scan
        return nil unless block_given?

        self.current = self.head
        # If you are not familiar with ruby this is the recommended way to write: do { p } while (q);
        loop do
            yield self.current
            break if (move_next == self.head)
        end
    end

    # Finds the first occurence that matched the given predicate.
    # Complexity: O(n).
    def find_first &predicate
        return nil unless block_given?

        self.current = self.head
        loop do
            return self.current if predicate.call(self.current)
            break if (move_next == self.head)
        end
    end

    # Prints the contents of the list.
    # Complexity: O(n).
    def print_list
        orig_curr = self.current  # Since buffer.full_scan will change the buffer.current
        if self.length == 0
            puts "empty"
        else
            self.full_scan { |node| print node.data }
			puts ""
        end
        self.current = orig_curr
    end

    def print_with_current
        orig_curr = self.current  # Since buffer.full_scan will change the buffer.current
        # buffer.full_scan { |node| if node.data == currMarble then print "(#{node.data})" else print " #{node.data} " end }
        self.full_scan { |node| print (node == orig_curr) ? "(#{node.data})" : " #{node.data} " }
        puts ""
        self.current = orig_curr
	end
end