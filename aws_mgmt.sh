function ec2describe()
{
 aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
}

ec2describe=`aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text > /tmp/intances`
while :
do
  clear

  # Menu
  echo "----- Welcome to AWS Condole Managment-----"
  echo ""
  echo "----- Choose one of this options to see: "
  echo "----- 1. Instances"
  echo "----- 2. Volumes"
  echo "----- 3. Load Balancers"
  echo "----- 4. VPC's"
  echo "----- 5. Exit"
  # The choice
  read -p "Insert the number you choose: " choice

  # Checking all the cases
  case $choice in
  1)
    clear

    # Getting the number of running instance and of intances
    running_intances_count=`aws ec2 describe-instances --filter Name=instance-state-name,Values=running --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text | wc -l`
    echo $running_intances_count
    all_instance_count=`aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text | wc -l`

    # Show all the instance we have
    echo "---- We have $all_instance_count instances, $running_intances_count running: "
    aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text | wc -l

    key=0
    while [ $key -ne 3 ]
    do
      # Menu of all instances
      echo "Choose: "
      echo ""
      echo "1. To see all our running instances"
      echo "2. To see all our stopped instances"
      echo "3. To see all our Main Site instances"
      echo "4. To see all our DR instances "
      echo "5. To see a specifiv Instance"
      echo "6. Go back to Menu"
      read key

      case $key in
      1)
        echo "Running Instances:"
        cat /tmp/intances | grep running
        ;;
      2)
        cat /tmp/intances | grep stopped
        ;;
      3)
        
       clear
       ;;
      esac
#aws ec2 describe-instances --filter Name=tag:Name,Values=STG-PUBLIC-WEB-2 --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
    done
  esac
done
#aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output texta
#aws ec2 describe-instances --filter Name=instance-state-name,Values=running --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
