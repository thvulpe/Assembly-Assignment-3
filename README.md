# 🔍 Composite Palindrome Checker – IOCLA Homework 3

> 📝 [Assignment Description – TEMA 3](https://gitlab.cs.pub.ro/iocla/tema-3-2025)

## 👨‍💻 Author
**Theodor Vulpe**
Bachelor Student @ Faculty of Automatic Control and Computers (ACS), UPB

## 💻 Course
**IOCLA – Introduction to Computer Systems**  
Spring 2025, University Politehnica of Bucharest

---

## 🧠 Overview

This project implements a set of four tasks in C, focused on pointer manipulation, string processing, recursion, and backtracking. All tasks are solved with performance and correctness in mind, with manual memory handling.

---

## 📌 Task Breakdown

### 🧩 Task 1: Linked List Reconstruction
- Given a list of nodes with values from `1` to `n`, rebuild a properly ordered linked list.
- Traverse the array, identify the correct node using its value, and link it to the last processed one.
- Special care is taken to handle the head of the list correctly.

### 📚 Task 2: Word Sorting
- Tokenize the input string into words using `strtok`.
- Sort the words using `qsort`, with a comparator that prioritizes **word length** and **lexicographical order** in case of ties.

### 🔢 Task 3: k-Fibonacci Sum
- Implement the recursive computation of the `k-Fibonacci` series:  
  `KFib(n) = KFib(n-1) + KFib(n-2) + ... + KFib(n-k)`
- Loop through all values from `1` to `K`, summing up the result at each step.

### 🔁 Task 4: Max Composite Palindrome Finder
- Use backtracking to generate **all subsets** of a given list of words.
- For each subset, concatenate the selected words and check if the resulting string is a **palindrome**.
- Track the **longest** and (in case of tie) **lexicographically smallest** palindrome.
