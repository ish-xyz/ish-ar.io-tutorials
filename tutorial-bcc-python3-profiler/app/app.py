#!/bin/python
#
"""
Social Media Analytics App
"""
import time

class SocialMediaAnalytics():

    def __init__(self, user):
        """
        Class constructor
        """
        self.user = user

    def login(self, social):
        """
        Login into a supported
            social media platform
        """
        time.sleep(3)
        self.session = {
            "user": self.user,
            "platform": social,
            "token": "8abe6942-6253-11ea-bc45-005056c00001"
        }
        return self.session

    def get_likes(self, session):
        """
        Get likes
        """
        time.sleep(5)
        return {
            "profile": self.user,
            "likes": 50000,
            "pictures": 100
        }

    def get_followers(self, session):
        """
        Get Followers
        """
        time.sleep(3)
        return {
            "profile": self.user,
            "followers": 700
        }

    def run_analytics(self, social):
        """
        Run analytics on profile
        """
        session = self.login(social)
        likes = self.get_likes(session)
        followers = self.get_followers(session)

        time.sleep(3)
        return {
            "followers": followers["followers"],
            "likes": likes["likes"],
            "pictures": likes["pictures"],
            "engagement": likes["likes"] / likes["pictures"] / followers["followers"]
        }

app = SocialMediaAnalytics("ish-ar.io")
analytics_instagram = app.run_analytics("instagram")
print(analytics_instagram)