import boto3
import logging

# Setup simple logging for INFO
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize the RDS and EC2 clients
rds_client = boto3.client('rds')
ec2_client = boto3.client('ec2')

TAG_KEY = 'AutoOn'  # Key for the tag
TAG_VALUE = 'True'  # Value you want to check for

def lambda_handler(event, context):
    # Start RDS instances
    manage_rds_instances()

    # Start EC2 instances
    manage_ec2_instances()

    return {
        'statusCode': 200,
        'body': 'Operation completed'
    }

def manage_rds_instances():
    # Get a list of all RDS instances
    response = rds_client.describe_db_instances()

    for db_instance in response['DBInstances']:
        db_instance_id = db_instance['DBInstanceIdentifier']

        # Get the tags for the DB instance
        tags_response = rds_client.list_tags_for_resource(
            ResourceName=db_instance['DBInstanceArn']
        )
        tags = {tag['Key']: tag['Value'] for tag in tags_response['TagList']}

        # Check if the DB instance has the specified tag
        if TAG_KEY in tags and tags[TAG_KEY] == TAG_VALUE:
            # Check the instance's current status
            if db_instance['DBInstanceStatus'] == 'stopped':
                # Start the DB instance
                logger.info(f'Starting RDS instance: {db_instance_id}')
                rds_client.start_db_instance(DBInstanceIdentifier=db_instance_id)

def manage_ec2_instances():
    # Get a list of all EC2 instances
    response = ec2_client.describe_instances()

    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']

            # Get the tags for the EC2 instance
            tags = {tag['Key']: tag['Value'] for tag in instance.get('Tags', [])}

            # Check if the EC2 instance has the specified tag
            if TAG_KEY in tags and tags[TAG_KEY] == TAG_VALUE:
                # Check the instance's current state
                if instance['State']['Name'] == 'stopped':
                    # Start the EC2 instance
                    logger.info(f'Starting EC2 instance: {instance_id}')
                    ec2_client.start_instances(InstanceIds=[instance_id])