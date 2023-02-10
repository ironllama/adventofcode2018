# Source: https://gist.github.com/amiralles/874feaa611c1316b7f99155b70822fa3

require_relative "./linked_list.rb"

class DoublyLinkedList < LinkedList
	class Node < LinkedList::Node
		attr_accessor :prev
	end

	# Inserts a new item into the list.
	# Complexity: O(1).
	def insert data
		node = Node.new data
		unless head
			self.head = node
		else
			node.prev = self.tail
			self.tail.next = node
		end
		self.tail = node
		self.length += 1
	end

	# Removes an item from the list.
	# Complexity: O(1). (In this case we have back pointers.)
	def remove node
		return nil unless node

		if node == head
			if head.next.nil?
				self.head = self.tail = nil
			else
				self.head = self.head.next
			end
		else
			p = node.prev
			n = node.next
			p&.next = n
			n&.prev = p
		end
		self.length -= 1
	end

	# Concatenates a list and the end of the current list.
	# Complexity O(1).
	def cat list
		return nil unless list

		list.head.prev = self.tail
		self.tail.next = list.head
		self.tail = list.tail
		self.length += list.length
	end

	# Finds the first occurrence of predicate
	# starting from the tail of the list.
	# Complexity O(n).
	def find_last &predicate
		return nil unless block_given?

		current = self.tail
		while current
			return current if predicate.call(current)
			current = current.prev
		end
	end


	# Walks the list from tail to head yielding items one at time.
	# Complexity: yield prev element is O(1),
	#             yield all elements is O(n).
	def reverse_each
		return nil unless block_given?

		current = self.tail
		while current
			yield current
			current = current.prev
		end
	end

	# Prints the contents of the list backward.
	# Complexity: O(n).
	def reverse_print
		if self.length == 0
			puts "empty"
		else
			self.reverse_each { |item| puts item.data }
		end
	end

end