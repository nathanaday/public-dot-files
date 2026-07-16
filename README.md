# public-dot-files

Configuration I use with my day-to-day tools, published in case any of it is useful to someone else.
Right now that means a couple of Claude Code skills for writing documentation.

## Skills

- `writing-documentation-prose` — for docs pages, design notes, module overviews, and PR
  descriptions. Pushes prose toward being clear instead of impressive-sounding.
- `writing-readme-files` — for a project's front page. Names the ways generated READMEs go
  wrong (rehashing the prompt, tracking progress, empty jargon) and gives a structure that
  convinces a reader the project is worth their time.

## Installing a skill

Skills are directories containing a `SKILL.md`. Claude Code reads them from two places:

- `~/.claude/skills/` — available in every project
- `<project>/.claude/skills/` — available in that project only, and checked in with the repo

Copy the ones you want into whichever location fits:

```
git clone https://github.com/nathanaday/public-dot-files.git
cp -r public-dot-files/claude/writing-readme-files ~/.claude/skills/
```

Or symlink instead, so `git pull` in the clone updates the skill in place:

```
ln -s "$PWD/public-dot-files/claude/writing-readme-files" ~/.claude/skills/writing-readme-files
```

Run `/skills` in Claude Code to confirm the skill was picked up. Claude invokes a skill on its
own when the task matches the `description` in its frontmatter; you can also ask for one by name.
