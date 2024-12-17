# Quickdraw

<img src="quickdraw.png" alt="Quickdraw" width="128">

> [!WARNING]
> Quickdraw is currently in development. You should almost definitely not use it in a project until `1.0` is released.

Quickdraw is a new test framework for Ruby:

- Designed to take advantage of multi-core systems. On M-series macs, it runs one process for each performance core.
- Efficiency mode on M-series macs can run on just your efficiency cores to save battery.
- Auto-loaded configuration, so you never need to `require "test_helper"`.
- Scoped execution, so you can define methods and constants at the top level without worrying about collisions.
- Watch mode automatically runs tests when files are updated.
- Error messages are calculated lazily, so you don’t need to worry about expensive (but helpful) failure messages slowing down your tests.
