
while :
do
  clear

  # Menu
  echo "----- Welcome to AWS Console Managment-----"
  echo ""
  echo "----- Choose one of this options to see: "
  echo "----- 1. Instances"
  echo "----- 2. Volumes"
  echo "----- 3. Load Balancers"
  echo "----- 4. VPC's"
  echo "----- 5. Route53"
  echo "----- 6. S3"
  echo "----- 6. Exit"
  # The choice
  read -p "Insert the number you choose: " choice

  # Checking all the cases
  # -------------------- Instances ----------------------
  case $choice in
  1)
    clear
    
    echo "Getting all the instances of our organiaztion ..."

    # Getting the number of running instance and of intances
    running_intances_count=`aws ec2 describe-instances --filter Name=instance-state-name,Values=running --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text | wc -l`
    all_instance_count=`aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text | wc -l`

    # Show all the instance we have
    echo "---- We have $all_instance_count instances, $running_intances_count running: "
    aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text

    key=0
    while [ $key -ne 4 ]
    do
      # Menu of all instances
      echo ""
      echo "1. Describe - To see all our instances in every state"
      echo "2. Describe - To see all our instances per zone"
      echo "3. Describe - To see a specific Instance"
      echo "4. Start/Stop - Start or stop an Instance"
      echo "5. Go back to Menu"
      read -p "[Choice + Enter] : " key

      # Every case
      case $key in

      # Instances in every state
      1)
        read -p "Select the state of the instance (pending | running | shutting-down | terminated | stopping | stopped ): " state
        aws ec2 describe-instances --filter Name=instance-state-name,Values=$state --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
        ;;

      # Zones
      2)
        read -p "The Availability Zone of the instance: " zone
        aws ec2 describe-instances --filter Name=availability-zone,Values=$zone --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
        ;;

      # Specific instance with id or name
      3)
        read -p "Insert the InstanceID or Instance Name: " id_name
        if [[ $id_name == 'i-'* ]]
        then
            aws ec2 describe-instances --instance-ids $id_name  --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
        else
        aws ec2 describe-instances --filter Name=tag:Name,Values=$id_name --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
        fi
       ;;

      # Start or Stop Instance
      4)
        read -p "Insert the InstanceId/Ids [if its more than one so put spcae between each one] : " instances
        read -p "Do you want to start or stop your instances? [start/stop] : " choice

	# Start Instances
        if [ $choice == "start" ]
        then
            read -p "Are you sure you want to Start the instances: $instances ?[y/n]: " answer
            if [ $answer == "y"]
            then
                echo "Starting Instances $instances ..."
                aws ec2 start-instances --instance-ids $instances
                #aws ec2 start-instances --instance-ids i-35a99cbd
            else
                echo "Back to Menu"
            fi

        # Stop Instances
        elif [ $choice == "stop" ]
               read -p "Are you sure you want to Stop the instances: $instances ?[y/n]: " answer
            if [ $answer == "y"]
            then
                echo "Stopping Instances $instances ..."
                aws ec2 stop-instances --instance-ids $instances
            else
                echo "Back to Menu"
            fi
        then
        fi
       ;;
      5)
        clear
        ;;
      esac
    done
  esac
done
#aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output texta
#aws ec2 describe-instances --filter Name=instance-state-name,Values=running --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
#aws ec2 describe-instances --filter Name=tag:Name,Values=STG-PUBLIC-WEB-2 --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
