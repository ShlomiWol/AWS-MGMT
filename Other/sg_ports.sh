#$1 = vpcID

# Count number of sg
sg_count=`aws ec2 describe-security-groups --filters Name=vpc-id,Values=$1 --query 'SecurityGroups[*].[GroupId]' --output text | wc -l`

# Going over all sg's
for (( i=0; i<$sg_count; i++ ))
do
   echo "---------------"

   # Showimg the details
   aws ec2 describe-security-groups --filters Name=vpc-id,Values=$1 --query ''SecurityGroups[$i].[GroupName,GroupId]'' --output text 
   aws ec2 describe-security-groups --filters Name=vpc-id,Values=$1 --query ''SecurityGroups[$i].IpPermissions[*].[IpRanges[*].CidrIp,FromPort,IpProtocol]'' --output text
done
