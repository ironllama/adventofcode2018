# Source: https://gist.github.com/amiralles/48a3198f8800b42f0b1de4dc00a3e4c8

class LinkedList
	class Node
		attr_accessor :next, :data
		def initialize data
			self.data = data
			self.next = nil
		end
	end

	attr_accessor :head, :tail, :length

	# Initialize an empty lits.
	# Complexity: O(1).
	def initialize
		self.head   = nil
		self.tail   = nil
		self.length = 0
	end

	# Inserts a new item into the list.
	# Complexity: O(1).
	def insert data
		node = Node.new data
		unless head
			self.head = node
		else
			self.tail.next = node
		end
		self.tail = node
		self.length += 1
	end

	# Removes an item from the list.
	# Complexity: O(n).
	def remove node
		return nil unless node

		if node == head
			if head.next.nil?
				self.head = self.tail = nil
			else
				self.head = self.head.next
			end
		else
			tmp = self.head
			while tmp && tmp.next != node
				tmp = tmp.next
			end
			tmp.next = node.next if tmp
		end
		self.length -= 1
	end

	# Removes all items form the list.
	# Complexity: O(n).
	def clear
		while self.length > 0
			remove self.head
		end
	end

	# Conviniece methods

	# Concatenates a list and the end of the current list.
	# Complexity O(1).
	def cat list
		return nil unless list

		self.tail.next = list.head
		self.length += list.length
	end

	# Finds first occurence of predicate.
	# Complexity: O(n).
	def find_first &predicate
		return nil unless block_given?

		current = self.head
		while current
			return current if predicate.call(current)
			current = current.next
		end
	end

	# Enumerator (common ruby idiom).
	# Loops over the list and yields items one by one.
	# Complexity: yield next element is O(1),
	#             yield all elements is O(n).
	def each
		return nil unless block_given?

		current = self.head
		while current
			yield current
			current = current.next
		end
	end

	# Prints the contents of the list.
	# Complexity: O(n).
	def print
		if self.length == 0
			puts "empty"
		else
			self.each { |item| puts item.data }
		end
	end

end