#!/usr/bin/env python3

#pykgmgr 0.1 - pkgmgr-lite in python3!
#Copyright (c) 2018 Jan-Daniel Kaplanski
#
#This project is based upon/contains parts of:
#pkgmgr 0.1cL
#Copyright (c) 2018 Jan-Daniel Kaplanski
#DBISshit! - the python app that mimics a database
#Copyright (c) 2018 Jan-Daniel Kaplanski
#
#
#                            Help on Parameters
#infldr
#   is your installation folder where pkgmgr puts the binaries
#   for standard behaviour set it to $HOME/pkgmgr/bin
#pkgfldr
#   is the working directory of pkgmgr and is ideally set to $HOME/pkgmgr
#   it will auto-create on first run
#repo
#   is the path to the online software repo
#   using https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo
#arch
#   your PC's architecture
#   currently supported: i386, amd64, python2, python3

#Release defaults
#infldr = "$HOME/pkgmgr/bin"
#pkgfldr = "$HOME/pkgmgr"
#ARCHfldr = "ARCH"
#repo = "https://gitup.uni-potsdam.de/kaplanski/pkgmgr/raw/master/repo"
#arch=""

#my config
infldr = "$HOME/pkgmgr/bin"
pkgfldr = "$HOME/pkgmgr"
ARCHfldr = "ARCH"
repo_srv = "https://gitup.uni-potsdam.de/"
repo_fldr = "kaplanski/pkgmgr/raw/master/repo"
arch =""

###-------imports------###

from subprocess import call
from datetime import datetime
from time import sleep
from sys import argv
from sys import stdin
from io import open
import http.client

###-------imports------###
###----helpful-stuff---###

def diftime():
 try:
  dtn = datetime.now().strftime("%H:%M").split(":")
  dtu = datetime.utcnow().strftime("%H:%M").split(":")
  dif_h = int(dtn[0]) - int(dtu[0])
  dif_m = int(dtn[1]) - int(dtu[1])
  if dif_h < 0: dif_h = abs(dif_h); dif = "-"
  else: dif = "+"
  dif = dif + str(dif_h).zfill(2) + str(dif_m).zfill(2) + "UTC"
  return dif
 except: print("ERR - TIME_DIF_CALC_FAILED")

def gettime():
 try: return str(datetime.now().replace(microsecond=0).isoformat())
 except: return "ERR - GETTIME_FAILED"

def mytime():
 try: return gettime() + diftime()
 except: return "ERR - MYTIME_FAILED"

###----helpful-stuff---###
###------commands------###

def connect(repository):
 global srv
 try:
  srv = https.client.HTTPSConnection(repository)
  srv.request("GET", "/")
  srv_resp = srv.getresponse()
  print(str(srv_resp.status) + str(srv_resp.reason) )
 except: False

def write(filename, content):
 try:
  open(filename, mode='wb').write(content)
  print("Write to " + str(filename) + " sucessfull!")
 except: print("Failed to write " + str(filename) + "!")

###------commands------###
###----pre-runtime----###

def info():
 print("-------------------------------------------------")
 print("-          pykgmgr - pkgmgr in python3          -")
 print("-    Copyright (c) 2018 Jan-Daniel Kaplanski    -")
 print("-------------------------------------------------")
 print("")

def help():
 print("Usage: " + argv[0] + " [-c|-da|-di|-h|-i|-r|-s|-u] [pkg]")
 print("   -c: cleans the package folder of downloaded packages")
 print("   -h: displays this help")
 print("   -u: updates the package index")
 print("   -i [pkg]: installs a package (-ri: reinstall)")
 print("   -r [pkg]: removes a package")
 print("   -s [pkg]: searches for a package in the package index")
 print("  -da: list all available packages for $arch")
 print("  -di: list all installed packages for $arch")
 print("  -ca [arch]: change your architecture")
 print("Current binary folder: $infldr")
 print("Current pkgmgr folder: $pkgfldr")
 print("Current architecture: $arch")

###----pre-runtime----###
###------runtime------###

def main():
 if True:
 #try:
  if len(argv) >= 2:
   if argv[1] == "-h":
    info()
    help()
   elif argv[1] == "-c": connect(repo_srv)
   elif argv[1] == "-u": False
   elif argv[1] == "-i": False
   elif argv[1] == "-r": False
   elif argv[1] == "-s": False
   elif argv[1] == "-da": False
   elif argv[1] == "-di": False
   elif argv[1] == "-ca": False
  elif len(argv) < 2:
   info()
   print("At least one argument required!")
   print("Try: " + argv[0] + " help (or specifiy a file)!")
 #except: print("ERR - UNKNOWN_ERROR")

###------runtime------###
###-----execution-----###

main()

###-----execution-----###
###------comments-----###
###------comments-----###
