echo "All the PREPROD Servers:"

# Getting number of PreProd Isntances
instances_count=`aws ec2 describe-instances --filter Name=tag:Environment,Values=PREPROD --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text | wc -l`

# Showing all the PREP instances
aws ec2 describe-instances --filter Name=tag:Environment,Values=PREPROD --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text
read -p "Are you sure you want to Stop the instances($instances_count)? [y/n]: " answer

# If user insert yes stop theinstances
if [ $answer == "y" ]
then

    # Getting all instances id
    ids=`aws ec2 describe-instances --filter Name=tag:Environment,Values=PREPROD --query 'Reservations[*].Instances[*].[InstanceId, PrivateIpAddress, InstanceType, State.Name, Placement.AvailabilityZone, Tags[1].Value, Tags[0].Value]' --output text | awk '{print $1}'`

    # Stopping the instances
    aws ec2 stop-instances --instance-ids $ids

    # Checking if all instance stopped
    while [ `aws ec2 describe-instances --instance-ids $ids --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' --output text | grep stopped | wc -l` != $instances_count ]
    do
      date "+DATE: %d/%m/%y%nTIME: %H:%M:%S"
      aws ec2 describe-instances --instance-ids $ids --query 'Reservations[*].Instances[*].[InstanceId, State.Name]' --output text
      sleep 2
    done
else
    echo "Ok so comeback when you want"
    echo "Bye Bye"
fi
