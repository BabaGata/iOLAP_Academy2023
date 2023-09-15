import json
import boto3
import logging
import sys

dynamoDB = boto3.resource('dynamodb', region_name= 'eu-central-1')
s3_client = boto3.client('s3', region_name = 'eu-central-1')
cicd_name = 'avujic-academy-'
logging.basicConfig(
    format='%(asctime)s.%(msecs)03d %(levelname)s %(module)s - %(funcName)s: %(message)s',
    stream=sys.stdout,
    level=logging.INFO
)
logger = logging.getLogger("avujic-academy-logging-cloudformation")
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    for suffix in ['global', 'jobs']:
        data_loaded = False
        table = dynamoDB.Table(cicd_name + suffix)
        if table.item_count==0:
            try:
                json_data = s3_client.get_object(
                    Bucket = 'avujic-academy-scripts',
                    Key = 'dynamodb/items/avujic-academy-imdb-'+suffix+'.json'
                )
                table_data = json.loads(json_data['Body'].read())
                logger.info('Received table data:\n' + str(table_data))

                if suffix=='global':
                    table.put_item(
                        Item = {
                            'name':table_data['name'],
                            'tz':table_data['tz'],
                            'method':table_data['method'],
                            'host':table_data['host'],
                            'port':table_data['port'],
                            'prefix':table_data['prefix'],
                            'url':table_data['url'],
                            'partitions_uri':table_data['partitions_uri'],
                            'jobs':table_data['jobs']
                        }
                    )
                    logger.info('Saved ' + str(table_data) + ' to ' + cicd_name + suffix)
                elif suffix=='jobs':            
                    for data in table_data:
                        table.put_item(
                            Item = {
                                'table_name':data['table_name'],
                                'uri':data['uri'],
                                'min_ingestion_dttm':data['min_ingestion_dttm']
                            }
                        )
                        logger.info('Saved ' + str(data) + ' to ' + cicd_name + suffix)
                data_loaded = True
            
            except Exception as e:
                logger.error(e)
    
            finally:
                logger.info('Data loaded: ' + str(data_loaded))
    return data_loaded