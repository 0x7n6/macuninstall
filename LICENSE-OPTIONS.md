# License options

This project intentionally does not ship with a `LICENSE` file yet so the repository owner can choose deliberately before publishing.

This is a practical comparison, not legal advice.

## Recommended default: MIT

Choose **MIT** if the goal is:

- maximum adoption
- easy reuse in personal and commercial projects
- forks and modifications with minimal obligations
- a very short, familiar license

Trade-off:

- someone may take the code, modify it, and redistribute the result under a proprietary license, while preserving the required copyright/license notice.

For a small command-line utility intended to spread widely, MIT is the simplest default.

## Apache License 2.0

Choose **Apache-2.0** if you want a permissive license like MIT but prefer more explicit terms around patents and contributions.

Good fit when:

- you want commercial use and permissive reuse
- you want an express patent license/grant structure
- you do not mind a longer license
- you are comfortable maintaining attribution/NOTICE requirements when applicable

For a project that may eventually receive substantial outside contributions, Apache-2.0 is a strong permissive choice.

## GPL-3.0

Choose **GPL-3.0** if your priority is keeping distributed derivative versions open source under the GPL.

Good fit when:

- you actively want copyleft
- you do not want redistributed modified versions to become closed-source derivatives
- you are fine with stronger redistribution obligations

Trade-off:

- some companies and developers avoid GPL dependencies or incorporation because of copyleft obligations.

## BSD-2-Clause

Choose **BSD-2-Clause** if you want something very close in spirit to MIT: short, permissive, and widely understood.

For this project there is usually little practical reason to prefer it over MIT unless you simply prefer BSD wording/tradition.

## Practical recommendation for macuninstall

### Pick MIT if:

> "I want as many Mac users and developers as possible to use, fork, package, and improve this."

This is the recommended choice for the current project.

### Pick Apache-2.0 if:

> "I want permissive open source, but I also value explicit patent language."

### Pick GPL-3.0 if:

> "If somebody distributes a modified version, I want that derivative to remain open source under GPL."

## GitHub setup

When creating the repository on GitHub, either:

1. create it without a license and add your chosen license afterward, or
2. use GitHub's license picker to add MIT, Apache-2.0, or GPL-3.0.

Do not invent a custom license unless you have a specific legal reason. Standard open-source licenses are easier for users, package maintainers, and contributors to understand.
