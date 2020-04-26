﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MenuController : MonoBehaviour
{

    public int upgradePoints = 0;
    
    public GameObject upgradeMenu;
    public Text pointDisplay;
    
    public void Update()
    {
        if (Input.GetKeyDown(KeyCode.I))
        {
            upgradeMenu.SetActive( !upgradeMenu.activeSelf );
        }

        pointDisplay.text = "points: " + upgradePoints;
    }

    public void PlayGame()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }

}
