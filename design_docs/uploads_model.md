# Proposal for an "uploads" model

## Motivation

Right now, the codebase has a number of file upload opportunities. Most models that have file uploads associated with them get four or so fields for each type of upload:

    FOO_file_name
    FOO_content_type
    FOO_file_size
    FOO_updated_at

### Code Maintainance

This results in duplicate code (backend and frontend). This means extra work when changing upload-related things, and increased possibility of things getting out of sync.

Some refactoring has already been done (eg., `shared/amazon_s3_upload`), but more could be done if the upload model were consolidated (see below).

### Migrations

Also as it currently stands, every time a need arises for a new file upload type, it results in a schema migration. Migrations are a chokepoint in the develop/test/deploy cycle. The larger the dev team gets, the more this will be the case. Because of `schema.rb`, migrations frequently end up forcing developers to rebase; regardless, changes that involve migrations entail more process than changes that don't.

### Testing

A factored "upload" object would be easier to test than a large number of disparate upload objects.

### History

As currently implemented, history of old uploads is not stored straightforwardly in the data model (although it may be stored incidentally in logs, emails, etc.).

### Garbage Collection

Because there is no straightforward history, there is no obvious good way to garbage collect S3. Cost is probably not an issue, but there may be other motivations for garbage collecting.

## Proposal


### Model

Proposed is a table along the following lines:

    CREATE TABLE uploads {
      id integer,
      created_at,
      updated_at,

      file_name,
      content_type,
      file_size,

      uploaded_by INTEGER, // REFERENCES users
      project_id INTEGER,  // REFERENCES projects
      upload_type VARCHAR(255),  // eg., cover_template_raw_cover (is this the best name for this?)

      hidden_at TIMESTAMP WITHOUT TIME ZONE,  // NULL means not hidden
      hidden_by INTEGER,  // REFERENCES users
      hidden_reason VARCHAR(255),
    };

### Usage

In order to add a new file upload type--for example, the "raw\_cover" upload recently added to `cover_template`--code could simply invoke an upload of a file with `upload_type` set to "cover\_template\_raw\_cover" or something like that. This would not require a schema change/migration.

To see the current "raw\_cover", there would be a method on the `Uploads` model (`Uploads#get_current` perhaps?) with args `project_id, upload_type`. This method would do something like

```
SELECT * FROM uploads WHERE project_id = ?  AND upload_type = ? AND hidden_at IS NULL ORDER DESC BY created_at LIMIT 1
```

Also, the following query would produce a history of that type:

```
SELECT * FROM uploads WHERE project_id = ?  AND upload_type = ? AND hidden_at IS NULL ORDER DESC BY created_at
```

`hidden_BAR` fields could be used to "revert" to a previous version of a file while still keeping a record of the new version.

A more nuanced query on the uploads table could produce a timeline of current files.

etc.

If a need arises to actually delete files from S3, the corresponding uploads rows could be deleted at the same time as the S3 files (or just before, really...). (Or there could be `deleted_BAR` fields as well? But this seems like it might be overkill. Thoughts?)
