from flask import Flask, request, redirect, render_template, session
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = "your_secret_key"

# Database Connection
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="8592821366",
        database="internship"
    )



# 1. Login Page
@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        
        db = get_db_connection()
        cursor = db.cursor()
        cursor.execute("select user_id, password ,user_type from users where email = %s", (email,))
        user = cursor.fetchone()
        db.close()
        
        if user and user[2]=="student" and  check_password_hash(user[1], password):
            session["user_id"] = user[0]
            return redirect("/profile")
        elif user and user[2]=="company" and  check_password_hash(user[1], password):
            session["user_id"] = user[0]
            return redirect("/company_profile")
        else:
            return "Invalid credentials. <a href='/'>Try again</a>"

    return render_template("login.html")








# 2. Signup Page
@app.route("/signup", methods=["GET", "POST"])
def signup():
    if request.method == "POST":
        name = request.form["name"]
        email = request.form["email"]
        password = generate_password_hash(request.form["password"])
        user_type = request.form["user_type"]  # Extract user type

        db = get_db_connection()
        cursor = db.cursor()
        
        try:
            cursor.execute("insert into users (name, email, password, user_type) values (%s, %s, %s, %s)", 
                           (name, email, password, user_type))
            db.commit()
            db.close()
            return redirect("/")
        except mysql.connector.IntegrityError:
            db.close()
            return "Email already exists. <a href='/signup'>Try again</a>"

    return render_template("signup.html")


@app.route("/profile", methods=["GET"])
def profile():
    if "user_id" not in session:
        return redirect("/")
    
    db = get_db_connection()
    cursor = db.cursor()
    user_id = session["user_id"]

    # Fetch user details
    cursor.execute("select name, email from users where user_id = %s", (user_id,))
    user = cursor.fetchone()

    # Fetch education details
    cursor.execute("select degree, university, graduation_year from education where user_id = %s", (user_id,))
    education = cursor.fetchone()

    # Fetch skills
    cursor.execute("""
        select skills.skill_name 
        from user_skills 
        join skills on user_skills.skill_id = skills.skill_id 
        where user_skills.user_id = %s
    """, (user_id,))
    user_skills = [row[0] for row in cursor.fetchall()]

    db.close()

    return render_template("profile.html", user=user, education=education, skills=user_skills)

@app.route("/edit_education", methods=["GET", "POST"])
def edit_education():
    if "user_id" not in session:
        return redirect("/login")  # Redirect if not logged in

    user_id = session["user_id"]
    db = get_db_connection()  # Create a new database connection
    cursor = db.cursor()

    if request.method == "POST":
        degree = request.form.get("degree")
        university = request.form.get("university")
        graduation_year = request.form.get("graduation_year")

        if not (degree and university and graduation_year):
            return "All fields are required!", 400

        cursor.execute("select * from education where user_id = %s", (user_id,))
        existing_education = cursor.fetchone()

        if existing_education:
            cursor.execute("""
                update education 
                set degree = %s, university = %s, graduation_year = %s 
                WHERE user_id = %s
            """, (degree, university, graduation_year, user_id))
        else:
            cursor.execute("""
                insert into education (user_id, degree, university, graduation_year) 
                values (%s, %s, %s, %s)
            """, (user_id, degree, university, graduation_year))

        db.commit()
        
        db.close()
        return redirect("/profile")  # Redirect to profile after update

    cursor.execute("select degree, university, graduation_year from education where user_id = %s", (user_id,))
    education = cursor.fetchone()
    
    db.close()

    return render_template("edit_education.html", education=education)

@app.route("/edit_skills", methods=["GET", "POST"])
def edit_skills():
    if "user_id" not in session:
        return redirect("/")

    db = get_db_connection()
    cursor = db.cursor()
    user_id = session["user_id"]

    # Fetch all available skills
    cursor.execute("SELECT skill_name FROM skills")
    all_skills = [row[0] for row in cursor.fetchall()]

    # Fetch user's existing skills
    cursor.execute("""
        SELECT skills.skill_name 
        FROM user_skills 
        JOIN skills ON user_skills.skill_id = skills.skill_id
        WHERE user_skills.user_id = %s
    """, (user_id,))
    user_skills = [row[0] for row in cursor.fetchall()]

    if request.method == "POST":
        selected_skills = request.form.getlist("skills")  # Get selected skills from form

        # Convert skill names to IDs
        cursor.execute("SELECT skill_id, skill_name FROM skills")
        skill_mapping = {row[1]: row[0] for row in cursor.fetchall()}

        selected_skill_ids = [skill_mapping[skill] for skill in selected_skills if skill in skill_mapping]

        # Delete old skills
        cursor.execute("DELETE FROM user_skills WHERE user_id = %s", (user_id,))
        
        # Insert new skills
        for skill_id in selected_skill_ids:
            cursor.execute("INSERT INTO user_skills (user_id, skill_id) VALUES (%s, %s)", (user_id, skill_id))

        db.commit()

        return redirect("/profile")

    db.close()
    return render_template("edit_skills.html", all_skills=all_skills, user_skills=user_skills)







@app.route("/company_profile")
def company_profile():
    if "user_id" not in session:
        return redirect("/")

    company_id = session["user_id"]

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    # Fetch company details
    cursor.execute(
        "SELECT user_id, name, email, created_at FROM users WHERE user_id = %s AND user_type = 'company'", (company_id,))
    company = cursor.fetchone()

    if not company:
        db.close()
        return "Company not found."

    # Fetch company's internships
    cursor.execute(
        "SELECT internship_id, title, description, skill_required, stipend, duration, posted_at FROM internships WHERE company_id = %s",
        (company_id,))
    internships = cursor.fetchall()

    db.close()

    return render_template("company_profile.html", company=company, internships=internships)






@app.route("/add_internship", methods=["POST", "GET"])
def add_internship():
    if "user_id" not in session:
        return "Unauthorized access"

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)
    
    if request.method == "POST":
        company_id = session["user_id"]
        title = request.form.get("title", "")
        description = request.form.get("description", "")
        selected_skill = request.form.get("skill_required", "")
        stipend = request.form.get("stipend", "")
        duration = request.form.get("duration", "")

        try:
            # Get skill_id from skill name
            cursor.execute("SELECT skill_id FROM skills WHERE skill_name = %s", (selected_skill,))
            skill_row = cursor.fetchone()
            if not skill_row:
                return "Invalid skill selected"

            skill_id = skill_row["skill_id"]

            # Insert into internships with skill name (for readability)
            sql_intern = """INSERT INTO internships (company_id, title, description, skill_required, stipend, duration) 
                            VALUES (%s, %s, %s, %s, %s, %s)"""
            values_intern = (company_id, title, description, selected_skill, stipend, duration)
            cursor.execute(sql_intern, values_intern)
            db.commit()

            # Get the new internship_id
            internship_id = cursor.lastrowid

            # Insert into company_skills table
            cursor.execute(
                "INSERT INTO company_skills (skill_id, internship_id) VALUES (%s, %s)",
                (skill_id, internship_id)
            )
            db.commit()

        except mysql.connector.Error as err:
            db.rollback()
            return f"Database error: {err}"
        finally:
            cursor.close()
            db.close()

        return redirect("/company_profile")

    # GET request — fetch all skill names for dropdown
    cursor.execute("SELECT skill_name FROM skills")
    all_skills = [row["skill_name"] for row in cursor.fetchall()]
    cursor.close()
    db.close()

    return render_template("add_internship.html", all_skills=all_skills)



@app.route("/delete_internship", methods=["GET", "POST"])
def delete_internship():
    if "user_id" not in session:
        return redirect("/")

    company_id = session["user_id"]
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    message = ""
    
    if request.method == "POST":
        internship_id = request.form.get("internship_id")

        # Check if internship exists and belongs to this company
        cursor.execute(
            "SELECT * FROM internships WHERE internship_id = %s AND company_id = %s",
            (internship_id, company_id)
        )
        internship = cursor.fetchone()

        if internship:
            try:
                # Delete from company_skills first (if foreign key constraint)
                cursor.execute("DELETE FROM company_skills WHERE internship_id = %s", (internship_id,))
                # Then delete from internships
                cursor.execute("DELETE FROM internships WHERE internship_id = %s", (internship_id,))
                db.commit()
                message = f"Internship ID {internship_id} deleted successfully."
            except mysql.connector.Error as err:
                db.rollback()
                message = f"Error deleting internship: {err}"
        else:
            message = "Invalid internship ID or you are not authorized to delete it."

    # Show all internships of this company
    cursor.execute(
        "SELECT internship_id, title, posted_at FROM internships WHERE company_id = %s ORDER BY posted_at DESC",
        (company_id,)
    )
    internships = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template("delete_internship.html", internships=internships, message=message)



@app.route("/matching_internships", methods=["GET", "POST"])
def matching_internships():
    if "user_id" not in session:
        return redirect("/")

    user_id = session["user_id"]
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    message = None
    message_type = None

    if request.method == "POST":
        internship_id = request.form.get("internship_id")

        cursor.execute("SELECT * FROM applications WHERE internship_id = %s AND student_id = %s", (internship_id, user_id))
        if cursor.fetchone():
            message = "You have already applied to this internship."
            message_type = "warning"
        else:
            cursor.execute("INSERT INTO applications (internship_id, student_id) VALUES (%s, %s)", (internship_id, user_id))
            db.commit()
            message = "Application submitted successfully!"
            message_type = "success"

    query = """
        SELECT DISTINCT i.internship_id, i.title, i.description, i.stipend, i.duration, i.posted_at
        FROM user_skills us
        JOIN company_skills cs ON us.skill_id = cs.skill_id
        JOIN internships i ON cs.internship_id = i.internship_id
        WHERE us.user_id = %s
        ORDER BY i.posted_at DESC
    """
    cursor.execute(query, (user_id,))
    internships = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template("matching_internships.html", internships=internships, message=message, message_type=message_type)

@app.route("/company_applications")
def company_applications():
    if "user_id" not in session:
        return redirect("/")
    
    company_id = session["user_id"]
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    query = """
        SELECT 
            a.internship_id,
            a.student_id,
            i.title AS internship_title,
            i.posted_at,
            u.name AS student_name,
            u.email AS student_email
        FROM applications a
        JOIN internships i ON a.internship_id = i.internship_id
        JOIN users u ON a.student_id = u.user_id
        WHERE i.company_id = %s
        ORDER BY i.posted_at DESC
    """
    cursor.execute(query, (company_id,))
    applications = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template("company_applications.html", applications=applications)



# 7. Logout
@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")



if __name__ == "__main__":
    app.run(debug=True)
