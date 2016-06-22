
# -------------------- Instances ----------------------
    
echo "Getting all the instances of our organization ..."

# Getting the number of running instance and of intances
running_intances_count=`aws ec2 describe-instances --filter Name=instance-state-name,Values=running --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text | wc -l`
all_instance_count=`aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text | wc -l`

# Show all the instance we have
echo "---- We have $all_instance_count instances, $running_intances_count running: "
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text

key=0
while [ $key -ne 8 ]
do
  # Menu of all instances
  echo ""
  echo "1. See all our instances in every state"
  echo "2. See all our instances per zone"
  echo "3. See a specific Instance"
  echo "4. Start/Stop - Start or Stop an Instance"
  echo "5. Create EC2 snapshot"
  echo "6. Create EC2 Instances"
  echo "7. Termintate EC2 Instances"
  echo "8. Go back to Menu"
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
   
   # Create Instance
   5)
     echo "Not Supported in Ireland"
     clear
    ;;
   esac
done
#aws ec2 describe-instances --filter Name=tag:Name,Values=STG-PUBLIC-WEB-2 --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
