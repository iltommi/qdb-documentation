Tags
****

Tags are strings that you can apply to one or more aliases. You can then search on the tags to quickly locate groups of aliases.

Names
^^^^^^^^^

Tags can be named with almost any string, just like alias. Tags cannot share names with entries. If an entry with name `t` exists, there cannot be a tag `t`.

Tags cannot start with the string "qdb".

Meta-tags
^^^^^^^^^

Tags are treated similarly to aliases and can be added to and removed from other tags. This allows you to create searchable meta-tags.

Transactions
^^^^^^^^^^^^

Tag operations are automatically wrapped in transactions.
