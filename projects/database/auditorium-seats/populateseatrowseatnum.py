import mysql.connector

# Connecting to database
mydb = mysql.connector.connect(
	host = "localhost",
	user = "root",
	password = "password"
)

# Instantiating the Python-SQL Bridge for executing commands
mycursor = mydb.cursor()

# Constants for rows
rowCount = 25
excludedRows = ['I']
startRow = 'A'
segmentRow = 'R'

def getRows():
	arr = []
	skip = 0
	segment = False
	segmentIncrement = 0
	for increment in range(rowCount):
		if (chr(ord(startRow) + increment + skip) in excludedRows):
			skip += 1
		if (not segment):
			if (chr(ord(startRow) + increment + skip) > segmentRow):
				segment = True
				skip = 0
				segmentIncrement = increment
		if segment:
			arr.append(chr(ord(startRow) + increment + skip - segmentIncrement) * 2)
		else:
			arr.append(chr(ord(startRow) + increment + skip))
	return arr

# Inclusive range of Seat Numbers
numRanges = [[1, 15], [101, 126]]

def generateListOfNumbers(start, end):
	return [*range(start, end+1)]

def getNums():
	arr = []
	for numRange in numRanges:
		arr.append(generateListOfNumbers(numRange[0], numRange[1]))
	finarr = []
	for ls in arr:
		finarr += ls
	return finarr

def populateRows():
	rows = getRows()
	sql = "insert into SeatRow values(%s)"
	for row in rows:
		val = (row)
		mycursor.execute(sql, val)
		mydb.commit()

def populateNums():
	nums = getNums()
	sql = "insert into SeatNum values(%s)"
	for num in nums:
		val = (num)
		mycursor.execute(sql, val)
		mydb.commit()

def populateDatabase():
	populateRows()
	populateNums()

mydb.close()