from selenium import webdriver
from bs4 import BeautifulSoup
from openpyxl import Workbook
import time

links = []

driver = webdriver.Chrome()
driver.get('https://www.indeed.com/q-Data-Scientist-jobs.html')

for i in range(1,10):
    driver.execute_script('window.scrollTo(0,document.body.scrollHeight)')
    time.sleep(2)

    page_source = driver.page_source
    soup = BeautifulSoup(page_source, 'lxml')
    jobs = soup.find_all('a', class_='jobtitle turnstileLink ')

    for job in jobs:
        link = job['href']
        link = "https://www.indeed.com" + link
        links.append(link)

    elements = driver.find_elements_by_xpath('//*[@class="pagination"]/a')

    python_button = elements[len(elements)-1]
    python_button.click()
    time.sleep(2)

    try:
        python_button = driver.find_element_by_xpath('//*[@id="popover-close-link"]')
        python_button.click()
        time.sleep(2)
    except:
        time.sleep(1)

for link in links:
    wb = Workbook()
    ws = wb.active
    row = 1
    for link in links:
        ws.cell(row = row, column = 1).value = link
        row += 1

    wb.save('data_science_links.xlsx')

driver.close()

