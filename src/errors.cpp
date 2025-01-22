#include <expected>
#include <string>
#include "errors.h"

Error::Error(std::string message) : message_(std::move(message)) {}

const std::string& Error::what() const {
	return message_; 
}
