## TL;DR

- I tried something a little different: replicating a graph that I enjoy on R
- I chose OWID's Self-reported life satisfaction vs GDP per capita, 2022
- A lot of it was trial and error, especially where the theme was concerned
- Great exercise on data wrangling and ggplot2 aesthetics

   ### Original plot:

  ![image](https://github.com/user-attachments/assets/b7c44838-99a5-402b-9e4d-9ccb98d37187)

  ### Final plot:

  ![image](https://github.com/user-attachments/assets/a0563218-1ad9-471b-934e-1a55d1cf4a41)

## Step by Step 

- Packages loaded were 'ggplot2', 'ggrepel', 'showtext', 'readr', 'dplyr', 'janitor'
- Data was downloaded from the OWID website

  ### Using the janitor package to clean the data

  - The first thing I did with the dataframe loaded into R was to rename columns and exclude NA values
  - Then, I filtered so only the latest year reported would remain
  - The first issue found was that the 'continent' column had been excluded. It was a big thing, since the bubbles are colored according to the continent of each entity
      - So, I created a new dataframe selecting only the 'entity' and 'continent' columns
      - Then, I used left_join() to add 'continent' to the main dataframe

  ### Plot: Bubbles

  - I decided to plot each element of the graph, beginning with the bubbles
  - The plot displays countries as bubbles, with size proportional to population, position indicating GDP per capita (x-axis) and life satisfaction (y-axis), and color representing the continent
  - I spent some time trying to figure out how stroke color and a fill! In the end, I found out at ttps://ggplot2.tidyverse.org/articles/ggplot2-specs.html that the shape has to be between 21-24 for it to happen

    <details>
    
    <summary>  </summary>
    
    ![image](https://github.com/user-attachments/assets/b75544fa-6444-4718-9f1d-e7d3abe0b5b3)
    
    
    ![image](https://github.com/user-attachments/assets/7b866b2e-6579-4b1c-add2-c107999b0545)
    
    </details>


  ### Plot: Highlights

  - Manually, I created a vector with the countries I want to display on my final plot

    <details>
    
    <summary>  </summary>
    
    ![image](https://github.com/user-attachments/assets/fadff9bb-c979-4fd1-bf53-0804e8959125)
      
    ![image](https://github.com/user-attachments/assets/77046c1f-a764-4b75-81ae-0cb7b2ce6ece)
    
    </details>

  ### Plot: Further Aesthetics

  - The x-axis is logarithmic with labels for specific values (1000, 2000, 5000, …, 100000) formatted with commas and a dollar sign. The y-axis uses simple integers from 3 to 7
  - It was a bit of trial and error, but i had to use scale_size_continuous because the default size of bubbles in ggplot2 was too small

    <details>
    
    <summary>  </summary>

    ![image](https://github.com/user-attachments/assets/5c8a3df0-6f69-4166-8da7-40cfa75933cf)

    ![image](https://github.com/user-attachments/assets/cac0e1b1-f066-42c6-b6de-e70b11150e17)

    </details>

  ### Plot: Theme

  - I created vectors for the text elements and added the Lato and Playfair Displays fonts using google_add_font
  - For the theme, I used theme_minimal() as a template, as I believe it was the closes to the OWID piece
    - I begin by removing the minor panel grids and adjusting the major panel grids
    - Then, I modify the text elements and make slight adjustments to the legend and plot margins
    - Again, it was a lot of trial and error to figure out the right proportions!

  <details>
    
  <summary>  </summary>

  ![image](https://github.com/user-attachments/assets/9b3a3516-0621-4169-946a-2371b15e805b)

  </details>

  After joining all elements, we have the final plot!

  <details>
    
  <summary>  </summary>

  ![image](https://github.com/user-attachments/assets/9dce35eb-b65d-4242-98c9-f3cc65e8acfa)

  </details>





   


