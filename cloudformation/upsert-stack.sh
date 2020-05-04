while [ $# -gt 0 ]; do
  case "$1" in
    --stack_name=*)
      stack_name="${1#*=}"
      ;;
    --template_body=*)
      template_body="${1#*=}"
      ;;
    --parameters=*)
      parameters="${1#*=}"
      ;;
    --region=*)
      region="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done


if [ -z "$stack_name" ]
then
	stack_name="capstone-project"
fi
if [ -z "$template_body" ]
then
	template_body="flask-app-network.yaml"
fi
if [ -z "$parameters" ]
then
	parameters="flask-app-network-parameters.json"
fi
if [ -z "$region" ]
then
	region="us-west-2"
fi
echo "stack-name is $stack_name"
echo "template-body is $template_body"
echo "parameters is $parameters"
echo "region is $region"
echo ""
echo ""

if aws cloudformation describe-stacks --stack-name $stack_name --region=$region; then
	echo ""
	echo "$stack_name already exist updating..."
	echo ""
	aws cloudformation update-stack \
	--stack-name $stack_name \
	--template-body file://$template_body  \
	--parameters file://$parameters \
	--region=$region \
	--capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"
else
	echo ""
	echo "\n\n$stack_name does not exist, creating..."
	echo ""
	aws cloudformation create-stack \
	--stack-name $stack_name \
	--template-body file://$template_body  \
	--parameters file://$parameters \
	--region=$region \
	--capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"
fi