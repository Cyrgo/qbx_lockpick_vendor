qbx_lockpick_vendor
===================

Simple lockpick vendor for Qbox/QBCore servers.

- Spawns an NPC vendor at the configured coords.
- ox_target interaction with two options:
  - Browse Lockpicks (opens ox_inventory shop UI)
  - Quick Buy (enter quantity; server validates and charges)
- Prices and blip are configurable via `config.lua`.

Requirements
------------
- ox_lib
- ox_inventory
- ox_target
- qbx_core (for GetPlayer/Notify helpers)

Install
-------
- Place the resource under `[standalone]/qbx_lockpick_vendor`.
- Ensure it after ox_lib, ox_inventory and ox_target.
- Configure prices, ped and blip in `config.lua` if desired.

Start
-----
Add to your server.cfg (if you don't already `ensure [standalone]`):

```
ensure qbx_lockpick_vendor
```

Make a separate repo
--------------------
From your project root:

Option A: copy out the folder and init a fresh repo

```
cp -a txData/Qbox_A037BC.base/resources/[standalone]/qbx_lockpick_vendor /path/to/new/repo
cd /path/to/new/repo
git init && git add . && git commit -m "feat: initial release"
# create a GitHub repo, then:
# git remote add origin git@github.com:<you>/qbx_lockpick_vendor.git
# git push -u origin main
```

Option B: subtree export (keeps history if using git)

```
# from your monorepo
git subtree split --prefix=txData/Qbox_A037BC.base/resources/[standalone]/qbx_lockpick_vendor -b qbx_lockpick_vendor
git clone .git worktree /path/to/new/repo -b qbx_lockpick_vendor
```

Config
------
See `config.lua`.

