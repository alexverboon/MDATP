# MDATP - Live Response

## File Analysis

findfile PotentiallyUnwanted.exe

fileinfo "c:\Users\Administrator\Downloads\PotentiallyUnwanted.exe"

getfile "c:\Users\Administrator\Downloads\PotentiallyUnwanted.exe" -upload

analyze file "c:\Users\Administrator\Downloads\PotentiallyUnwanted.exe"

Sample Result:

{
  "report": {
    "status": "infected",
    "total": 2,
    "verified": 0,
    "clean": 1,
    "has_file": false,
    "suspicious": 0,
    "file_hash": "00117f70c86adb0f979021391a8aeaa497c2c8df",
    "infected": 1,
    "behavior": {
      "Files": {
        "Deleted": null,
        "Modified": null,
        "Created": []
      }
    },
    "not_found": 0,
    "scans": [
      {
        "status": "clean",
        "scan_time": 1568360854.357407,
        "report": "",
        "source": "Deep Analysis"
      },
      {
        "status": "infected",
        "source": "Windows Defender Static Analysis Engines",
        "report": {
          "detected_by": "10 engines"
        },
        "scan_time": 1568360651.396473,
        "behavior": null
      },
      {
        "status": "infected",
        "source": "Virus Total",
        "report": {
          "detected_by": "48/67 AVs"
        },
        "scan_time": 1568360651.396926,
        "behavior": null
      }
    ]
  },
  "scan_status": "infected"
}

