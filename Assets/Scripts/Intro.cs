using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Intro : MonoBehaviour
{
    public GlitchIntro glitchIntro;
    private DialogTrigger dialogTrigger;
    
    private bool initiated = false;

    private void Start()
    {
        dialogTrigger = GetComponent<DialogTrigger>();
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        Debug.Log("ENTERED");
        if (!initiated)
        {
            Debug.Log("LETS GO");
            // initiated = true;
            StartCoroutine(InvokeDialog());
        }
    }

    private IEnumerator InvokeDialog()
    {
        StartCoroutine(glitchIntro.TriggerIntroEffect() );
        yield return new WaitForSeconds(1f);
        dialogTrigger.TriggerDialog();
        
    }
}
