#include <expected>
#include <string>

class Error {
	public:
		explicit Error(std::string message);
		const std::string& what() const;
	private:
		std::string message_;
};
