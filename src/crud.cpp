#include <memory>
#include <string>
#include <expected>
#include <sqlite3.h>
#include "errors.h"


const std::string enable_fts_sql = "PRAGMA journal_mode=WAL;";


const std::string create_table_sql =  R"(
	CREATE VIRTUAL TABLE IF NOT EXISTS items USING fts5(
		key, 
		description, 
		content='', 
		quantity UNINDEXED, 
		price UNINDEXED, 
		created_at UNINDEXED
	);
)";


struct SQLiteDeleter {
    void operator()(sqlite3* db) const {
        if (db) {
            sqlite3_close(db);
        }
    }
};


std::expected<
	sqlite3*,
	Error
> exec(
	sqlite3* db, 
	const std::string& sql
) {
	char* msg = nullptr;

	int rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &msg);
	if (rc != SQLITE_OK) {
		sqlite3_free(msg);
		return std::unexpected(Error(msg));
	}

	return db;
}


std::expected<
	std::unique_ptr<sqlite3, SQLiteDeleter>, 
	Error
> connect(
	const std::string& path
) {
	sqlite3* db = nullptr;

	int rc = sqlite3_open(path.c_str(), &db);
	if (rc != SQLITE_OK) {
		std::string msg = sqlite3_errmsg(db);
		sqlite3_close(db);

		return std::unexpected(Error(msg));
	}

	return std::unique_ptr<sqlite3, SQLiteDeleter>(db);
}

std::expected<
	sqlite3*,
	Error
> exec_enable_fts_sql(sqlite3* db) {
	return exec(db, enable_fts_sql);
}

std::expected<
	sqlite3*,
	Error
> exec_create_table_sql(sqlite3* db) {
	return exec(db, create_table_sql);
}


std::expected<
	sqlite3*,
	Error
> setup(
	sqlite3* db
) {
	return exec_enable_fts_sql(db)
		.and_then(exec_create_table_sql);

}

void search_for_contact() {}

void insert_contact() {}

void delete_contact() {}
