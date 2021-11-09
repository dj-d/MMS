# MMS

Merge Media Script is a script for concatenating and compressing video files

## Usage

| Param | Description        | Example         | Note                 |
| ----- | ------------------ | --------------- | -------------------- |
| -p    | Path of folder     | /path/to/folder |                      |
| -c    | Enable compression |                 |                      |
| -g    | Enable GPU         |                 | Only with GPU Nvidia |
| -h    | Help               |                 |                      |

## Example

```sh
./mergeScript.sh -p /path/to/folder -c -g
```

## Note

__IMPORTANT__: _Be sure to rename the files so that the names indicate the sequence for which they are to be concatenated_