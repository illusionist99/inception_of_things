#!/bin/sh

while true; do
    sleep 60
    PODS=$(kubectl get all -n kube-system)

    if [ $? -ne 0 ]; then
        echo "Error executing kubectl command. Make sure kubectl is installed and configured."
        exit 1
    fi

    all_running=true

    echo "$PODS" | tail -n +2 | while read -r LINE; do
        if ! echo "$LINE" | grep -Eq "Running|Completed"; then
            echo "Error: Not all pods are running."
            if ! echo "$LINE" | grep -q "ContainerCreating"; then
                echo "Restating k3s service."
                sudo service k3s restart
            fi
            all_running=false
            break
        fi
    done

    if [ "$all_running" = true ]; then
        break
    fi

done

echo "All pods are running."
