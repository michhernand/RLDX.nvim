local rolodex = require("rolodex")

local line = "abc def ghi"

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

describe("Test Rolodex AT WORD", function()
	it("is at first word", function()
		local start, finish = rolodex.get_word(line, "a")
		assert.are.equal(start, 1)
		assert.are.equal(finish, 3)
	end)

	it("is at last word", function()
		local start, finish = rolodex.get_word(line, "g")
		assert.are.equal(start, 9)
		assert.are.equal(finish, nil)
	end)
end)

describe("Test Rolodex FAIL", function()
	it("Doesn't Find Words", function()
		local start, finish = rolodex.get_word(line, "x")
		assert.are.equal(start, nil)
		assert.are.equal(finish, nil)
	end)
end)
