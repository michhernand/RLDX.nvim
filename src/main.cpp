// #include <iostream>
// #include <memory>
// #include <rocksdb/db.h>
// #include <string>
//
// void showMenu() {
//     std::cout << "Simple RocksDB CLI\n";
//     std::cout << "1. Put (key, value)\n";
//     std::cout << "2. Get (key)\n";
//     std::cout << "3. Delete (key)\n";
//     std::cout << "4. Exit\n";
//     std::cout << "Enter your choice: ";
// }
//
int main() {
//     // Define RocksDB options
//     rocksdb::Options options;
//     options.create_if_missing = true;
//
//     // Open a database with a unique pointer
//     std::unique_ptr<rocksdb::DB> db;
//     rocksdb::DB* raw_db = nullptr;
//     rocksdb::Status status = rocksdb::DB::Open(options, "testdb", &raw_db);
//
//     if (!status.ok()) {
//         std::cerr << "Error opening RocksDB: " << status.ToString() << std::endl;
//         return 1;
//     }
//
//     db.reset(raw_db); // Transfer ownership to unique_ptr
//
//     int choice;
//     std::string key, value;
//
//     while (true) {
//         showMenu();
//         std::cin >> choice;
//
//         switch (choice) {
//         case 1: // Put
//             std::cout << "Enter key: ";
//             std::cin >> key;
//             std::cout << "Enter value: ";
//             std::cin >> value;
//             status = db->Put(rocksdb::WriteOptions(), key, value);
//             if (status.ok()) {
//                 std::cout << "Key-Value pair added successfully.\n";
//             } else {
//                 std::cerr << "Error: " << status.ToString() << "\n";
//             }
//             break;
//
//         case 2: // Get
//             std::cout << "Enter key: ";
//             std::cin >> key;
//             status = db->Get(rocksdb::ReadOptions(), key, &value);
//             if (status.ok()) {
//                 std::cout << "Value: " << value << "\n";
//             } else {
//                 std::cerr << "Error: Key not found\n";
//             }
//             break;
//
//         case 3: // Delete
//             std::cout << "Enter key: ";
//             std::cin >> key;
//             status = db->Delete(rocksdb::WriteOptions(), key);
//             if (status.ok()) {
//                 std::cout << "Key deleted successfully.\n";
//             } else {
//                 std::cerr << "Error: " << status.ToString() << "\n";
//             }
//             break;
//
//         case 4: // Exit
//             std::cout << "Exiting...\n";
//             return 0;
//
//         default:
//             std::cout << "Invalid choice. Please try again.\n";
//         }
//     }
//
//     return 0;
}

