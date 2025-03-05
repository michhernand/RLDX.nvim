# Changelog

## v0.2.0 - Hash Salt Release
### Features
- Added randomly generated salt for all hashes.
- Updated schema version to v0.2.0.
- Maintaining support for schema v0.1.0 and v0.0.2.

### Fixes
- Small syntax fix in v0.1.0 middleware.

## v0.1.0 - Obfuscation Release
### Features
- Added optional obfuscation (via XOR encryption) of catalog when at rest.
- Added md5 hash of name as catalog key - to guarantee uniqueness.
- Added optional formatting of completions.
- Updated schema version to v0.1.0.
- Maintaining support for schema v0.0.2.
- Added automatic upgrade / downgrade of schema.

## v0.0.2 - Documentation Release
- Readme and instruction updates.

## v0.0.1 - Early Testing Release
- Minimal create / read functionality.

