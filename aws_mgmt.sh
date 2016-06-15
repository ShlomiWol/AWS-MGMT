
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
    while [ $key -ne 5 ]
    do
      # Menu of all instances
      echo ""
      echo "1. See all our instances in every state"
      echo "2. See all our instances per zone"
      echo "3. See a specific Instance"
      echo "4. Start/Stop - Start or Stop an Instance"
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
        read -p "Do you want to start or stop your instances? [start/stop] : " choice
        read -p "Insert the InstanceId [if its more than one so put spcae between each one] : " instances

	#Check how much instances are
	instances_count=`aws ec2 describe-instances --instance-ids $instances --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' --output text | wc -l`

	# Start Instances
        if [ $choice == "start" ]
        then
            read -p "Are you sure you want to Start the instances($instances_count): $instances ?[y/n]: " answer
            if [ $answer == "y" ]
            then
                # Starting
                echo "Starting Instances $instances ..."
                aws ec2 start-instances --instance-ids $instances
                
		# Checking if all instance running
                while [ `aws ec2 describe-instances --instance-ids $instances --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' --output text | grep running | wc -l` != $instances_count ]
                do
                  date
                  aws ec2 describe-instances --instance-ids $instances --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' --output text
                  sleep 1
                done
                
                # Finished the start operation, countinue to back menu
                read -p "Insert any key to back to menu ..."
            else
                echo "Back to Menu"
            fi        
        # Stop Instances
        elif [ $choice == "stop" ]
        then
            read -p "Are you sure you want to Stop the instances($instances_count): $instances ?[y/n]: " answer
            if [ $answer == "y" ]
            then
                echo "Stopping Instances $instances ..."
                aws ec2 stop-instances --instance-ids $instances
                
                # Checking if all instance stopped
                while [ `aws ec2 describe-instances --instance-ids $instances --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' --output text | grep stopped | wc -l` != $instances_count ]
                do
                  date
                  aws ec2 describe-instances --instance-ids $instances --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' --output text
                  sleep 1
                done
                
                # Finished the start operation, countinue to back menu
                read -p "Insert any key to back to menu ..."
            else
                echo "Back to Menu"
            fi
        fi
       ;;
      5)
        clear
        ;;
      esac
    done
    ;;
    #-------------------- End of Instances ---------------
    #--------------------- Volumes ---------------------
    2)
      clear
      echo "Getting all the volumes in our organization"	
      
      # Getting all the volumes in the organization
      vol_count=`aws ec2 describe-volumes --query 'Volumes[*].[VolumeId,Size,VolumeType,Attachments[0].State,State,Attachments[0].InstanceId,AvailabilityZone,CreateTime]' --output text | wc -l`
      in_use=`aws ec2 describe-volumes --query 'Volumes[*].[VolumeId,Size,VolumeType,Attachments[0].State,State,Attachments[0].InstanceId,AvailabilityZone,CreateTime]' --output text | grep in-use | wc -l`
      echo "We have $vol_count volumes, $in_use in use: "
      aws ec2 describe-volumes --query 'Volumes[*].[VolumeId,Size,VolumeType,Attachments[0].State,State,Attachments[0].InstanceId,AvailabilityZone,CreateTime]' --output text
      
      # Show every time the menu
      key=0
      while [key -ne 6]
      do
        echo ""
        echo "1. See a specific volume"
        echo "2. See volumes in specific region"
        echo "3. See state of volumes"
        echo "4. See the atached volumes to a specific Instance"
        echo "5. See size of volumes"
        echo "6. Go back to Menu"	

        read -p "[Choice + Enter] : " key
      
      
        # Cases
        case $key in
        1)
          read -p "Insert the VolumeId (If you insert more than one put space between them: " vols
          aws ec2 describe-volumes --volume-ids $vols --query 'Volumes[*].[VolumeId,Size,VolumeType,Attachments[0].State,State,Attachments[0].InstanceId,AvailabilityZone,CreateTime]' --output text
          ;;
        2)
          read -p "Insert region: " region
          aws ec2 describe-volumes --region $region --query 'Volumes[*].[VolumeId,Size,VolumeType,Attachments[0].State,State,Attachments[0].InstanceId,AvailabilityZone,CreateTime]' --output text
          ;;
        esac
      done
      ;;
    #---------------------- End of Volumes ----------------------------
  esac
done
#aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output texta
#aws ec2 describe-instances --filter Name=instance-state-name,Values=running --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
#aws ec2 describe-instances --filter Name=tag:Name,Values=STG-PUBLIC-WEB-2 --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
