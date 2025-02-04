local rolodex = require("rolodex")

local line = "abc def ghi"

local line2 = "ads are always available"

local line3 = "bill buys bananas in bundles at the store"

local line4 = "carmen demolishes data centers distinctly"

describe("Get Char", function()
	it("is the first char", function()
		local char, prev_char = rolodex.extract_chars(1, line)
		assert.are.equal(char, "a")
		assert.are.equal(prev_char, " ")
	end)

	it("is the second char", function()
		local char, prev_char = rolodex.extract_chars(2, line)
		assert.are.equal(char, "b")
		assert.are.equal(prev_char, "a")
	end)
end)

describe("Eval Char", function()
	it("can find start at the beginning of the line", function()
		local ix = 1
		local prefix = "a"
		local char, prev_char = rolodex.extract_chars(ix, line)
		local start, finish = rolodex.eval_char(ix, char, prev_char, prefix, nil)
		assert.are.equal(start, 1)
		assert.are.equal(finish, nil)
	end)

	it("can find start in the middle of the line", function()
		local ix = 5
		local prefix = "d"
		local char, prev_char = rolodex.extract_chars(ix, line)
		local start, finish = rolodex.eval_char(ix, char, prev_char, prefix, nil)
		assert.are.equal(start, 5)
		assert.are.equal(finish, nil)
	end)

	it("can find start at the end of the line", function()
		local ix = 9
		local prefix = "g"
		local char, prev_char = rolodex.extract_chars(ix, line)
		local start, finish = rolodex.eval_char(ix, char, prev_char, prefix, nil)
		assert.are.equal(start, 9)
		assert.are.equal(finish, nil)
	end)

	it("can find end at the beginning of the line", function()
		local ix = 4
		local prefix = "a"
		local char, prev_char = rolodex.extract_chars(ix, line)
		local start = 1
		local start, finish = rolodex.eval_char(ix, char, prev_char, prefix, start)
		assert.are.equal(start, 1)
		assert.are.equal(finish, 3)
	end)

	it("can find end in the middle of the line", function()
		local ix = 8
		local prefix = "d"
		local char, prev_char = rolodex.extract_chars(ix, line)
		local start = 5
		local start, finish = rolodex.eval_char(ix, char, prev_char, prefix, start)
		assert.are.equal(start, 5)
		assert.are.equal(finish, 7)
	end)

	it("cannot find end at the end of the line", function()
		local ix = 11
		local prefix = "g"
		local char, prev_char = rolodex.extract_chars(ix, line)
		local start = 9
		local start, finish = rolodex.eval_char(ix, char, prev_char, prefix, start)
		assert.are.equal(start, 9)
		assert.are.equal(finish, nil)
	end)
end)

describe("Get Words", function()
	it("is at multiple words (line2)", function()
		local starts, finishes = rolodex.get_words(line2, "a")
		assert.are.equal(#starts, 4)
		assert.are.equal(#finishes, 3)

		assert.are.equal(starts[1], 1)
		assert.are.equal(finishes[1], 3)

		assert.are.equal(starts[2], 5)
		assert.are.equal(finishes[2], 7)

		assert.are.equal(starts[3], 9)
		assert.are.equal(finishes[3], 14)

		assert.are.equal(starts[4], 16)
	end)

	it("is at multiple words (line3)", function()
		local starts, finishes = rolodex.get_words(line3, "b")
		assert.are.equal(#starts, 4)
		assert.are.equal(#finishes, 4)

		assert.are.equal(starts[1], 1)
		assert.are.equal(finishes[1], 4)

		assert.are.equal(starts[2], 6)
		assert.are.equal(finishes[2], 9)

		assert.are.equal(starts[3], 11)
		assert.are.equal(finishes[3], 17)

		assert.are.equal(starts[4], 22)
		assert.are.equal(finishes[4], 28)
	end)

	it("is at multiple words (line4)", function()
		local starts, finishes = rolodex.get_words(line4, "d")
		assert.are.equal(#starts, 3)
		assert.are.equal(#finishes, 2)

		assert.are.equal(starts[1], 8)
		assert.are.equal(finishes[1], 17)

		assert.are.equal(starts[2], 19)
		assert.are.equal(finishes[2], 22)

		assert.are.equal(starts[3], 32)
	end)
end)
