# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Dates for 0.1.7 and earlier are the dates of the version bump commits.

## [0.1.8] - Unreleased

### Fixed

- `Flybuy::Site.create` now returns a site built from the response's `data`
  key. Before, the returned site had no `id`, `name` or other attributes.
- `Flybuy::SiteStoreHours.create` now returns store hours built from the
  response's `data` key, with the same problem fixed.
- `Flybuy::SiteStoreHours.create` passes its client to the new store hours
  object. Before, it passed the class-level `@client`, which could be `nil`.

### Changed

- Gem `changelog_uri` metadata points to `CHANGELOG.md`.

## [0.1.7] - 2024-09-12

### Added

- `delivery_source` attribute on `Flybuy::ArchivedOrder`.
- `Flybuy::ArchivedOrder.hash(range)` returns archived orders as raw hashes.

### Fixed

- `Flybuy::Order#pickup_currently_open?` handles a blank order id or missing
  store hours (#24).

## [0.1.6] - 2024-07-11

### Added

- `Flybuy::Order#pickup_currently_open?` checks the site's store hours for the
  order's pickup type (#23).
- `Flybuy::SiteStoreHours#currently_open?`. Adds a dependency on `biz`.

## [0.1.5] - 2024-04-02

### Added

- `Flybuy::SiteStoreHours` API (#22).
- `all:` option on `Flybuy::Order.find_by_partner_identifier` to return every
  matching order (#21).

## [0.1.4] - 2023-11-28

### Fixed

- `Flybuy::Site.create` sets the client before posting (#20).

## [0.1.3] - 2023-08-11

### Added

- `pay_state` order attribute (#18).

## [0.1.2] - 2023-08-09

### Added

- `spot_identifier:` option on customer state updates (#17).

## [0.1.1] - 2023-08-08

### Added

- `Flybuy::Order#update_location` sends a location update event (#16).

## [0.1.0] - 2023-06-07

### Added

- Tags on order create (#15).

## [0.0.9] - 2023-05-03

### Added

- Tags on order update (#14).

### Fixed

- `authentic?` takes `token:` and `hmac_key:` keyword arguments (#13).
- Pagination uses the configured client URL (#12).

## [0.0.8] - 2023-04-20

### Added

- Configurable API URL (#11).

## [0.0.7] - 2023-04-15

### Added

- Webhook authentication (#10).

## [0.0.6] - 2022-10-07

### Added

- `Flybuy::Order#update` and `pos_identifier` attribute (#9).
- Customer state updates (#8).

## [0.0.5] - 2022-10-04

### Added

- Order creation (#7).
- Customer endpoint (#6).

## [0.0.4] - 2022-06-30

### Added

- Customer and archived order endpoints (#5).

### Fixed

- Find by partner identifier returns the first match from the response
  array (#4).

## [0.0.3] - 2022-02-28

### Added

- Order lookup and state change endpoints (#3).
- Site list (#2).

## [0.0.2] - 2022-02-18

### Changed

- Switched HTTP client from HTTParty to Net::HTTP (#1).

## [0.0.1] - 2022-02-17

- Initial release.
