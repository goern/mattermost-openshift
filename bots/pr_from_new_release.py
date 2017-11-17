#!/usr/bin/env python

import os 
import feedparser
import semver
import shutil

from dotenv import load_dotenv, find_dotenv

from dockerfile_parse import DockerfileParser
from git import Repo, Actor
from git.exc import GitCommandError
from github import Github


dockerfile_version = None
release_version = None
r = None
git_url = 'https://github.com/goern/mattermost-openshift.git'
LOCAL_WORK_COPY = './mattermost-openshift-workdir'
SSH_CMD = 'ssh -i id_deployment_key'
load_dotenv(find_dotenv())

def main():
    """lets start our task"""
    # clone the repo
    cleanup(LOCAL_WORK_COPY)
    try:
        r = Repo.clone_from(git_url, LOCAL_WORK_COPY)
    except GitCommandError as git_error:
        print(git_error)
        exit(-1)

    d = feedparser.parse(
        'https://github.com/mattermost/mattermost-server/releases.atom')
    release_version = d.entries[0].title[1:]

    # lets read the dockerfile of the current master
    dfp = DockerfileParser()

    with open('./mattermost-openshift-workdir/Dockerfile') as f:
        dfp.content = f.read()

    if 'MATTERMOST_VERSION' in dfp.envs:
        dockerfile_version = dfp.envs['MATTERMOST_VERSION']

    # Lets check if we got a new release
    if semver.compare(release_version, dockerfile_version) == 1:
        print("Updating from %s to %s" % (dockerfile_version, release_version))

        target_branch = 'bots-life/update-to-' + release_version

        if not pr_in_progress(target_branch):
            # patch_and_push(dfp, r, target_branch)
            cleanup(LOCAL_WORK_COPY)

            create_pr_to_master(target_branch)
        else:
            print("There is an open PR for %s, aborting..." %
                  (target_branch))

    else:
        print("we are even with Mattermost %s, no need to update" %
              release_version)


def cleanup(directory):
    """clean up the mess we made..."""
    try:
        shutil.rmtree(directory)
    except FileNotFoundError as fnfe:
        print("Non Fatal Error: " + str(fnfe))

def patch_and_push(dfp, repository, target_branch):
    """patch the Dockerfile and push the created branch to origin"""

    # lets create a new branch
    new_branch = repository.create_head(target_branch)
    new_branch.checkout()

    # set dockerfile version to release version
    dfp.envs['MATTERMOST_VERSION'] = release_version
    dfp.envs['MATTERMOST_VERSION_SHORT'] = release_version.replace('.', '')

    # and write back the Dockerfile
    with open('./mattermost-openshift-workdir/Dockerfile', 'w') as f:
        f.write(dfp.content)
        f.close()

    # commit our work
    repository.index.add(['Dockerfile'])
    author = Actor('Mattermost Server Updater Bot', 'goern+bot@b4mad.net')
    committer = Actor('Mattermost Server Updater Bot', 'goern+bot@b4mad.net')
    repository.index.commit("Update to Mattermost " + release_version,
                            author=author, committer=committer)

    # and push to origin
    with repository.git.custom_environment(GIT_SSH_COMMAND=SSH_CMD):
        repository.remotes.origin.push(refspec='{}:{}'.format(
            target_branch, target_branch))


def pr_in_progress(target_branch):
    """pr_in_progress() will check if there is an open PR from target_branch to master"""
    return True

def create_pr_to_master(target_branch):
    """create a github pr from target_branch to master"""
    git = Github(os.environ.get('GITHUB_ACCESS_TOKEN'))
    repo = git.get_user().get_repo('mattermost-openshift')

    print(repo.pulls_url)

    repo.create_pull('automated update',
                     'This PR is generated as part of an automated update triggered by a new Mattermost release.', 'master', target_branch)

if __name__ == '__main__':
    main()
