times = [44899691]
distances = [277113618901768]
ways = [0, 0, 0, 0]

for i in range(0, 1):
    print(times[i])
    print(distances[i])

    for j in range(0, times[i] + 1):
        #print(j)
        #print(j * (times[i] - j))

        if j * (times[i] - j) > distances[i]:
         #   print("won")
            ways[i] = ways[i] + 1

print('DONE!')
print(ways[0])

result  = 1

# brute force
for i in range(0, 1):
    time, distance = times[i], distances[i]

    no_ways = 0
    for speed in range(time):
        if speed * (time - speed) > distance:
            no_ways += 1
    
    result *= no_ways
    no_ways = 0

print(result)