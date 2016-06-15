while :
do
  clear

  # Menu
  echo "----- Welcome to AWS Condole Managment-----"
  echo ""
  echo "----- Choose one of this options to get: "
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
    ;;
  esac

done

aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
