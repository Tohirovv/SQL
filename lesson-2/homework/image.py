import pyodbc

# Connection string — update SERVER if needed
con_str = 'DRIVER={SQL Server};SERVER=LAPTOP-FAHM6P25\\SQLEXPRESS;DATABASE=lessons;Trusted_Connection=yes'

# Connect to SQL Server
con = pyodbc.connect(con_str)
cursor = con.cursor()

# Fetch image data from table
cursor.execute("SELECT id, image_data FROM photos WHERE id = 1")
row = cursor.fetchone()

if row:
    image_id, image_data = row
    # Save the image to a file
    with open(f'photo_{image_id}.jpg', 'wb') as f:
        f.write(image_data)
    print(f'Image saved as photo_{image_id}.jpg')
else:
    print('No image found with id = 1')

# Close connection
cursor.close()
con.close()
