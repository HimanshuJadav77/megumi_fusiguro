dict  = {"ID" : "1" ,"Name": "BCA",}
print("Dictinary is : ",dict) 

#Methods.....

#print vlaues..
print("\n")
print("ID is: ",dict["ID"])
print("Name is :",dict["Name"])

#print length..
print("\n")
print("Length of Dictionry: ",len(dict))

#print keys and values
x = dict.keys()
print("\n")
y = dict.values()


print("Keys are: ",x)
print("\n")
print("Values are : ",y)

#add new..
dict["Result"] = "Fail"

print("\n")
print("Dictionary is after add: ",dict)

#override..
dict["Name"] = "BSCIT"

#update values and add values..
dict.update({"ID" : "2"})
print("\n")
print("Dictionary after update",dict)

# Dictionary In For loop 
#print the key and value pair 
print("\n")
for x in dict:
    print(x, " : ", dict[x])
 #OR
print("\n")
for x,y in dict.items():
     print(x,":",y)   
# only values print
print("\n")
for x in dict.values():
    print(x)
# only key print 
print("\n")
for x in dict.keys():
    print(x)

#remove specific item
print("\n")
dict.pop("Name")
print("Delete Name Dict: ",dict)
#remove last item
print("\n")
dict.popitem()
print("Delete Last Item: ",dict)
#delete specific id/value
print("\n")
del dict["ID"]
print("After Delete ID",dict)
#delete dictionary
print("\n")
del dict  








