Tags
****

Tags are strings that you can apply to one or more entries. Any entry can be tagged, including other tags. Most tag functions are performed on the object itself::

    c = qdb.Client('qdb://127.0.0.1:2836')
    b = c.blob('myBlob')

    b.put('boom')
    b.add_tag('myTag')
    has_tag = b.has_tag('myTag')
    taglist = b.get_tags()
    b.removeTag('myTag')


You can also create a Tag instance by creating a Tag object from the cluster. Using the tag object, you can look up entries by their association with the tag or tag it with a meta-tag::

    t = c.tag('myTag')

    entry_list = t.get_entries()
    t.add_tag('is_tag')

    meta_tag = c.tag('is_tag')
    list_of_tags = meta_tag.get_entries()


Names
^^^^^^^^^

 * Tags can be named with almost any string, just like an alias.
 * Tags cannot share names with entries. If an entry with name `t` exists, there cannot be a tag `t`.
 * Tags must be valid UTF-8 strings.

Transactions
^^^^^^^^^^^^

Tag operations are automatically wrapped in transactions.
