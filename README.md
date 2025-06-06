# Hospital Monitoring - Shell Scripting Task

Group project about shell scripting. Simulates hospital devices and does log stuff.

## Setup

Run these in separate terminals:

```
python3 heart_monitor.py start
python3 temp_sensor.py start
python3 water_meter.py start
```

## Scripts

- `archive_logs.sh` - moves logs to archive folders
- `analyze_logs.sh` - counts stuff in the logs

Just run them and pick from the menu.

## Structure

```
active_logs/        - current logs
*_archive/          - old logs
reports/            - analysis output
```

## Group

- Joseph Rukundo
- [others tbd]

## Notes

- chmod +x the .sh files first
- ctrl+c to stop the python scripts
- creates folders automatically if missing
