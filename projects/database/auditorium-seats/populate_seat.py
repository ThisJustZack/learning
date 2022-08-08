import mysql.connector

# Connecting to database
mydb = mysql.connector.connect(
	host = "localhost",
	user = "root",
	password = "password"
)

# Instantiating the Python-SQL Bridge for executing commands
mycursor = mydb.cursor()

# Inclusive range of seat numbers per seat row
rownumRanges = {
	"A": [[1, 10], [101, 114]],
	"B": [[1, 10], [101, 116]],
	"C": [[1, 10], [101, 116]],
	"D": [[1, 11], [101, 116]],
	"E": [[1, 11], [101, 116]],
	"F": [[1, 11], [101, 118]],
	"G": [[1, 12], [101, 118]],
	"H": [[1, 12], [101, 118]],
	"J": [[1, 12], [101, 118]],
	"K": [[1, 13], [101, 120]],
	"L": [[1, 13], [101, 120]],
	"M": [[1, 13], [101, 120]],
	"N": [[1, 14], [101, 120]],
	"O": [[1, 14], [101, 120]],
	"P": [[1, 14], [101, 122]],
	"Q": [[1, 15], [101, 122]],
	"R": [[1, 15], [101, 122]],
	"AA": [[1, 13], [101, 124]],
	"BB": [[1, 14], [101, 124]],
	"CC": [[1, 14], [101, 124]],
	"DD": [[1, 14], [101, 126]],
	"EE": [[1, 10], [101, 122]],
	"FF": [[1, 10], [101, 122]],
	"GG": [[1, 11], [101, 120]],
	"HH": [[1, 11], [101, 118]]
}

# Rows that can have wheelchairs
wheelchairRows = ['P', 'Q', 'R']

def getWheelchair(SeatRow, SeatNum):
	if ((SeatRow in wheelchairRows) and (SeatNum >= 109)):
		return True
	return False

def getSection(SeatRow):
	if (len(SeatRow) == 1):
		return "Main Floor"
	return "Balcony"

def getSide(SeatNum):
	if (SeatNum <= 15):
		return "Middle"
	elif (SeatNum % 2 == 0):
		return "Right"
	return "Left"

def getPricingTier(SeatRow, SeatNum):
	if (len(SeatRow) == 1):
		if (SeatNum <= 106):
			return "Orchestra"
		return "Side"
	elif (SeatRow >= "EE"):
		return "Upper Balcony"
	elif (getSide(SeatNum) == "Middle"):
		return "Orchestra"
	return "Side"

def populateSeats():
	sql = "insert into Seat values(%s, %s, %s, %s, %s, %s)"
	for row in rownumRanges:
		arr = []
		for numRange in rownumRanges[row]:
			arr.append(generateListOfNumbers(numRange[0], numRange[1]))
		nums = []
		for ls in arr:
			nums += ls
		for num in nums:
			val = (row, num, getSection(row), getSide(num), getPricingTier(row, num), int(getWheelchair(row, num)))
			mycursor.execute(sql, val)
			mydb.commit()

mydb.close()
