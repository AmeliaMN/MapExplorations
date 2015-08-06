# -*- coding: utf-8 -*-
"""
Yelp API v2.0 code sample.

This program demonstrates the capability of the Yelp API version 2.0
by using the Search API to query for businesses by a search term and location,
and the Business API to query additional information about the top result
from the search query.

Please refer to http://www.yelp.com/developers/documentation for the API documentation.

This program requires the Python oauth2 library, which you can install via:
`pip install -r requirements.txt`.

Sample usage of the program:
# `python sample.py --term="bars" --location="San Francisco, CA"`
"""
import argparse
import json
import pprint
import sys
import urllib
import urllib2

import oauth2


API_HOST = 'api.yelp.com'
DEFAULT_TERM = 'Korean'
DEFAULT_LOCATION = 'Los Angeles, CA'
SEARCH_LIMIT = 20
SEARCH_OFFSET = 0
SEARCH_PATH = '/v2/search/'
BUSINESS_PATH = '/v2/business/'

# OAuth credential placeholders that must be filled in by users.
CONSUMER_KEY = 'BEkpAxaAeg7-BX82N_-aRg'
CONSUMER_SECRET = 'Pow3d9j3M6PEaiRtpOg7TYWeaKs'
TOKEN = 'YkiQzm8mLM_EC6Qvej7JpDvdDuzgM-zx'
TOKEN_SECRET = 'USHrWG5rXMmHXPP6DHP8OSuKdps'


def request(host, path, url_params=None):
    """Prepares OAuth authentication and sends the request to the API.

    Args:
        host (str): The domain host of the API.
        path (str): The path of the API after the domain.
        url_params (dict): An optional set of query parameters in the request.

    Returns:
        dict: The JSON response from the request.

    Raises:
        urllib2.HTTPError: An error occurs from the HTTP request.
    """
    url_params = url_params or {}
    encoded_params = urllib.urlencode(url_params)

    url = 'http://{0}{1}?{2}'.format(host, path, encoded_params)

    consumer = oauth2.Consumer(CONSUMER_KEY, CONSUMER_SECRET)
    oauth_request = oauth2.Request('GET', url, {})
    oauth_request.update(
        {
            'oauth_nonce': oauth2.generate_nonce(),
            'oauth_timestamp': oauth2.generate_timestamp(),
            'oauth_token': TOKEN,
            'oauth_consumer_key': CONSUMER_KEY
        }
    )
    token = oauth2.Token(TOKEN, TOKEN_SECRET)
    oauth_request.sign_request(oauth2.SignatureMethod_HMAC_SHA1(), consumer, token)
    signed_url = oauth_request.to_url()

    # print 'Querying {0} ...'.format(url)

    conn = urllib2.urlopen(signed_url, None)
    try:
        response = json.loads(conn.read())
    finally:
        conn.close()

    return response

def search(term, location, offset):
    """Query the Search API by a search term and location.

    Args:
        term (str): The search term passed to the API.
        location (str): The search location passed to the API.

    Returns:
        dict: The JSON response from the request.
    """
    url_params = {
        'term': term,
        'location': location,
        'limit': SEARCH_LIMIT,
        'offset': offset
    }

    return request(API_HOST, SEARCH_PATH, url_params=url_params)

def get_business(business_id):
    """Query the Business API by a business ID.

    Args:
        business_id (str): The ID of the business to query.

    Returns:
        dict: The JSON response from the request.
    """
    business_path = BUSINESS_PATH + business_id

    return request(API_HOST, business_path)

def query_api(term, location):
    """Queries the API by the input values from the user.

    Args:
        term (str): The search term to query.
        location (str): The location of the business to query.
    """
    SEARCH_OFFSET = 0
    for r in range(0, 25):
        response = search(term, location, SEARCH_OFFSET)

        businesses = response.get('businesses')
        if not businesses:
            print 'No businesses for {0} in {1} found.'.format(term, location)
            return

        for f in range(0,SEARCH_LIMIT):
            myFile = open('different_r.txt', 'a')
            myFile.write(str(businesses[f]['rating'])+',')
            myFile.write(str(businesses[f]['mobile_url'])+',')
            myFile.write(str(businesses[f]['review_count'])+',')
            myFile.write(str(businesses[f]['name'])+',')
            try:
                businesses[f]['location']['coordinate']
            except KeyError:
                businesses[f]['location']['coordinate'] = "{u'latitude': NA, u'longitude': NA}"
                #myFile.write("{u'latitude': NA, u'longitude': NA}")
            myFile.write(str(businesses[f]['location']['coordinate'])+',')
            myFile.write(str(businesses[f]['location']['display_address'])+',')
            myFile.write('\n')
            myFile.close()
        SEARCH_OFFSET = SEARCH_OFFSET + 20
        print(SEARCH_OFFSET)

def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('-q', '--term', dest='term', default=DEFAULT_TERM, type=str, help='Search term (default: %(default)s)')
    parser.add_argument('-l', '--location', dest='location', default=DEFAULT_LOCATION, type=str, help='Search location (default: %(default)s)')

    input_values = parser.parse_args()

    try:
        query_api(input_values.term, input_values.location)
    except urllib2.HTTPError as error:
        sys.exit('Encountered HTTP error {0}. Abort program.'.format(error.code))


if __name__ == '__main__':
    main()