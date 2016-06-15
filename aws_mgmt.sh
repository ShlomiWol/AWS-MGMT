
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
  echo "----- 6. Exit"
  # The choice
  read -p "Insert the number you choose: " choice

  # Checking all the cases
  case $choice in
  1)
    clear

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
      echo "1. To see all our instances in every state"
      echo "2. To see all our instances per zone"
      echo "3. To see a specific Instance"
      echo "4. Go back to Menu"
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

      # Chau
      4)
        clear
       ;;
      esac
    done
  esac
done
#aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output texta
#aws ec2 describe-instances --filter Name=instance-state-name,Values=running --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
#aws ec2 describe-instances --filter Name=tag:Name,Values=STG-PUBLIC-WEB-2 --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
