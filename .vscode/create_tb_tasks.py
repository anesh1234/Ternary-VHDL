import os
import json

def createTasks():
    testbench_root = "tvl_lib/old_testbench"
    tasks = []

    # Traverse subdirectories of testbench/
    for subdir in os.listdir(testbench_root):
        subdir_path = os.path.join(testbench_root, subdir)
        if os.path.isdir(subdir_path):
            for file in os.listdir(subdir_path):
                if file.endswith("_tb.vhdl"):
                    tb_name = file.replace("_tb.vhdl", "")
                    tb_dir = subdir
                    print(file)

                    # analyze & elaborate testbench

                    analyze_task = {
                        "label": f"ANA {tb_dir}_{tb_name}",
                        "type": "shell",
                        "command": f"ghdl -a --std=08 --work=work --workdir={testbench_root}/{tb_dir}/workdir -Ptvl_lib/workdir {testbench_root}/{tb_dir}/{tb_name}_tb.vhdl",
                        "problemMatcher": [],
                        "hide": True
                    }
                    elaborate_task = {
                        "label": f"ELA {tb_dir}_{tb_name}",
                        "type": "shell",
                        "command": f"ghdl -e --std=08 --work=work --workdir={testbench_root}/{tb_dir}/workdir -Ptvl_lib/workdir {tb_name}_tb",
                        "problemMatcher": [],
                        "hide": True
                    }
                    sequence_task1 = {
                        "label": f"Compile {tb_dir}_{tb_name}",
                        "dependsOn": [f"ANA {tb_dir}_{tb_name}", f"ELA {tb_dir}_{tb_name}"],
                        "dependsOrder": "sequence",
                        "problemMatcher": []
                    }

                    # run & simulate testbench

                    run_task = {
                        "label": f"run {tb_dir}_{tb_name}",
                        "type": "shell",
                        "command": f"ghdl -r {tb_name}_tb --wave={testbench_root}/{tb_dir}/workdir/{tb_name}_wave.ghw",
                        "problemMatcher": [],
                        "hide": True
                    }
                    gtk_task = {
                        "label": f"gtk {tb_dir}_{tb_name}",
                        "type": "shell",
                        "command": f"gtkwave {testbench_root}/{tb_dir}/workdir/{tb_name}_wave.ghw",
                        "problemMatcher": [],
                        "hide": True
                    }
                    sequence_task2 = {
                        "label": f"Sim {tb_dir}_{tb_name}",
                        "dependsOn": [f"run {tb_dir}_{tb_name}", f"gtk {tb_dir}_{tb_name}"],
                        "dependsOrder": "sequence",
                        "problemMatcher": []
                    }

                    tasks.extend([analyze_task, elaborate_task, sequence_task1, run_task, gtk_task, sequence_task2])

    return tasks

def truncSave(tasks: list):
    file_path = ".vscode/tasks.json"
    trunc_string = "//truncate"

    # Read the original file
    with open(file_path, "r") as file:
        lines = file.readlines()

    # Find the marker block
    marker_index = None
    for i in range(0, len(lines)):
        if trunc_string in lines[i]:
            marker_index = i
            break

    # Truncate everything after the marker block
    if marker_index is not None:
        truncated_lines = lines[:marker_index + 1]
    else:
        raise ValueError("Marker block not found in tasks.json")


    # Serialize each task individually and append without trailing comma
    for i, task in enumerate(tasks):
        serialized = json.dumps(task, indent=4)
        if i < len(tasks) - 1:
            truncated_lines.append(serialized + ",\n")
        else:
            truncated_lines.append(serialized + "\n]\n}")

    # Write back to the file
    with open(file_path, "w") as file:
        file.writelines(truncated_lines)

truncSave(createTasks())
print("----DONE----")

