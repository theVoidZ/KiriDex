using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class GlitchApplyLoop : MonoBehaviour
{
    public GlitchIntro glitchIntro;
    private DialogTrigger dialogTrigger;

    private bool initiated = false;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!initiated )
        {
            initiated = true;
            StartCoroutine(glitchIntro.TriggerLoopEffect());
            
            dialogTrigger = GetComponent<DialogTrigger>();
            if (dialogTrigger)
            {
                dialogTrigger.TriggerDialog();
            }
        }
    }
    
}
